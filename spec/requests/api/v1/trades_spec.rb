require 'rails_helper'

RSpec.describe 'Trade API', type: :request do
  before { host! 'api.binaryoptionsmanagement.local' }
  let!(:user) { create(:user) }
  let!(:auth_data) { user.create_new_auth_token }
  let!(:account) { create(:account, user_id: user.id) }
  let!(:strategy) { create(:strategy, user_id: user.id) }
  let(:headers) do
    {
        'Accept' => 'application/vnd.binaryoptionsmanagement.local',
        'Content-Type' => Mime[:json].to_s,
        'access-token' => auth_data['access-token'],
        'uid' => auth_data['uid'],
        'client' => auth_data['client']
    }
  end

  describe 'GET /trades' do

    context 'when params are not passed' do
      before do
        create_list(:trade, 10, account_id: account.id, user_id: user.id, strategy_id: strategy.id)
        get '/trades', params: {}, headers: headers
      end

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return a list of trades from database' do
        expect(json_body[:data].count).to eq(10)
      end
    end

    context 'when params are passed' do
      let!(:account2) { create(:account, user_id: user.id) }
      let!(:trade1) { create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy.id) }
      let!(:trade2) { create(:trade, account_id: account2.id, user_id: user.id, strategy_id: strategy.id) }
      let!(:trade3) { create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy.id) }
      let!(:trade4) { create(:trade, account_id: account2.id, user_id: user.id, strategy_id: strategy.id) }
      before do
        get "/trades?q[account_id_eq]=#{account.id}", params: {}, headers: headers
      end

      it 'return only account\'s trades' do
        trades = json_body[:data].map { |trade| trade[:id].to_i }

        expect(trades).to eq([trade1.id, trade3.id])
      end
    end
  end

  describe 'GET /trades/:id' do
    let(:trade) { create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy.id) }

    before do
      get "/trades/#{trade.id}", params: {}, headers: headers
    end

    it 'return status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'return trade data' do
      expect(json_body[:data][:attributes][:value]).to eq(trade.value.to_s)
    end
  end

  describe 'POST /accounts' do
    context 'when params are valid' do
      let(:trade_params) { attributes_for(:trade, account_id: account.id, strategy_id: strategy.id) }

      before do
        post '/trades', params: { trade: trade_params }.to_json, headers: headers
      end

      it 'return status code 201' do
        expect(response).to have_http_status(:created)
      end

      it 'save trade on database' do
        expect(Trade.find_by(value: trade_params[:value])).not_to be_nil
      end

      it 'return trade data' do
        expect(json_body[:data][:attributes][:value].to_d).to eq(trade_params[:value].to_d)
      end

      it 'associate with account, user and strategy' do
        expect(json_body[:data]).to have_relationships(:account, :user, :strategy)
      end

      it 'update account balance' do
        trade_account = Account.find(account.id)
        expect(trade_account.current_balance).to eq(account.initial_balance +
                                                        json_body[:data][:attributes][:result_balance].to_d)
      end
    end

    context 'when params are invalid' do
      let(:trade_params) { attributes_for(:trade, profit: nil, account_id: account.id) }
      before do
        post '/trades', params: { trade: trade_params }.to_json, headers: headers
      end

      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return errors' do
        expect(json_body).to have_key(:errors)
      end

      it 'not save trade on database' do
        expect { Trade.find_by!(profit: trade_params[:profit]) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT /trades/:id' do
    let!(:trade) { create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy.id) }
    before do
      put "/trades/#{trade.id}", params: { trade: trade_params }.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:trade_params) { { profit: 87 } }

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return updated trade data' do
        expect(json_body[:data][:attributes][:value]).not_to be_nil
      end

      it 'save updated data on database' do
        saved_trade = Trade.find(trade.id)
        expect(saved_trade.profit).to eq(trade_params[:profit])
      end

      it 'update account balance' do
        trade_account = Account.find(account.id)
        account_trades = trade_account.trades.sum(:result_balance)
        expect(trade_account.current_balance).to eq(account.current_balance + account_trades)
      end
    end

    context 'when params are invalid' do
      let(:trade_params) { { value: ' ' } }

      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return erros' do
        expect(json_body).to have_key(:errors)
      end

      it 'not save updates on database' do
        not_updated_trade = Trade.find(trade.id)
        expect(not_updated_trade.value).not_to eq(trade_params[:value])
      end
    end
  end

  describe 'DELETE /trades/:id' do
    let(:trade) { create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy.id) }

    before do
      delete "/trades/#{trade.id}", params: {}, headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'remove register from database' do
      expect { Trade.find(trade.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'update account balance' do
      trade_account = Account.find(account.id)
      account_trades = trade_account.trades.sum(:result_balance)
      expect(trade_account.current_balance).to eq(account.current_balance + account_trades)
    end
  end

  describe 'POST /trades/analytics' do

    context 'when account_id is selected and params are passed' do
      let!(:strategy1) { create(:strategy) }
      let!(:strategy2) { create(:strategy) }
      let!(:trade1) do
        create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy1.id,
                       created_at: '2020-08-01 00:00:00'.to_date)
      end
      let!(:trade2) do
        create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy2.id,
                       created_at: '2020-08-01 00:00:00'.to_date)
      end
      let!(:trade3) do
        create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy1.id,
                       created_at: '2020-08-02 00:00:00'.to_date)
      end
      let!(:trade4) do
        create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy2.id,
                       created_at: '2020-08-03 00:00:00'.to_date)
      end
      let!(:trade5) do
        create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy1.id,
                       created_at: '2020-08-03 00:00:00'.to_date)
      end
      before do
        post '/trades/analytics', params: { q: { account_id_eq: account.id, created_at_lteq: '2020-08-03'.to_date,
                                                 created_at_gteq: '2020-08-02'.to_date, strategy_id_eq: strategy1.id } }
          .to_json,
                                  headers: headers
      end

      it 'return only account\'s trades' do
        trades = json_body[:data].map { |trade| trade[:attributes][:account_id].to_i }

        expect(trades.uniq.size).to eq(1)
      end

      it 'return only trades that attend to params passed' do
        trades = json_body[:data].map { |t| t[:id].to_i }

        expect(trades).to eq([trade3.id, trade5.id])
      end

    end

    context 'when account_id is not selected' do
      before do
        create_list(:trade, 10, account_id: account.id, user_id: user.id, strategy_id: strategy.id)
        post '/trades/analytics', params: { q: { account_id_eq: nil } }.to_json, headers: headers
      end

      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return errors key' do
        expect(json_body).to have_key(:errors)
      end

    end
  end
end
