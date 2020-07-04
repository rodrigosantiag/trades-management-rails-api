require 'rails_helper'

RSpec.describe 'Trade API', type: :request do
  before {host! 'api.binaryoptionsmanagement.local'}
  let!(:user) {create(:user)}
  let!(:auth_data) {user.create_new_auth_token}
  let!(:account) {create(:account, user_id: user.id)}
  let!(:strategy) {create(:strategy, user_id: user.id)}
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

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should return a list of trades from database' do
        expect(json_body[:data].count).to eq(10)
      end
    end

    context 'when params are passed' do
      let!(:account2) {create(:account, user_id: user.id)}
      let!(:trade1) {create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy.id)}
      let!(:trade2) {create(:trade, account_id: account2.id, user_id: user.id, strategy_id: strategy.id)}
      let!(:trade3) {create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy.id)}
      let!(:trade4) {create(:trade, account_id: account2.id, user_id: user.id, strategy_id: strategy.id)}
      before do
        get "/trades?q[account_id_eq]=#{account.id}", params: {}, headers: headers
      end

      it 'should return only account\'s trades' do
        trades = json_body[:data].map {|trade| trade[:attributes][:'account-id'].to_i}

        expect(trades).to eq([trade1.account_id, trade3.account_id])
      end
    end
  end

  describe 'GET /trades/:id' do
    let(:trade) {create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy.id)}

    before do
      get "/trades/#{trade.id}", params: {}, headers: headers
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'should return trade data' do
      expect(json_body[:data][:attributes][:value]).to eq(trade.value.to_s)
    end
  end

  describe 'POST /accounts' do
    context 'when params are valid' do
      let(:trade_params) {attributes_for(:trade, account_id: account.id, strategy_id: strategy.id)}
      before do
        post '/trades', params: {trade: trade_params}.to_json, headers: headers
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'should save trade on database' do
        expect(Trade.find_by(value: trade_params[:value])).not_to be_nil
      end

      it 'should should return trade data' do
        expect(json_body[:data][:attributes][:'value'].to_d).to eq(trade_params[:value].to_d)
      end

      it 'should associate with account' do
        expect(json_body[:data][:attributes][:'account-id']).to eq(trade_params[:account_id])
      end

      it 'should associate with user' do
        expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
      end

      it 'should update account balance' do
        trade_account = Account.find(account.id)
        expect(trade_account.current_balance).to eq(account.initial_balance + json_body[:data][:attributes][:'result-balance'].to_d)
      end
    end

    context 'when params are invalid' do
      let(:trade_params) {attributes_for(:trade, profit: nil, account_id: account.id)}
      before do
        post '/trades', params: {trade: trade_params}.to_json, headers: headers
      end

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return errors' do
        expect(json_body).to have_key(:errors)
      end

      it 'should not save trade on database' do
        expect{Trade.find_by!(profit: trade_params[:profit])}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT /trades/:id' do
    let!(:trade) {create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy.id)}
    before do
      put "/trades/#{trade.id}", params: {trade: trade_params}.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:trade_params) {{profit: 87}}

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should return updated trade data' do
        expect(json_body[:data][:attributes][:value]).not_to be_nil
      end

      it 'should save updated data on database' do
        saved_trade = Trade.find(trade.id)
        expect(saved_trade.profit).to eq(trade_params[:profit])
      end

      it 'should update account balance' do
        trade_account = Account.find(account.id)
        account_trades = trade_account.trades.sum(:result_balance)
        expect(trade_account.current_balance).to eq(account.current_balance + account_trades)
      end
    end

    context 'when params are invalid' do
      let(:trade_params) {{value: ' '}}

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return erros' do
        expect(json_body).to have_key(:errors)
      end

      it 'should not save updates on database' do
        not_updated_trade = Trade.find(trade.id)
        expect(not_updated_trade.value).not_to eq(trade_params[:value])
      end
    end
  end

  describe 'DELETE /trades/:id' do
    let(:trade) {create(:trade, account_id: account.id, user_id: user.id, strategy_id: strategy.id)}

    before do
      delete "/trades/#{trade.id}", params: {}, headers: headers
    end

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'should remove register from database' do
      expect{Trade.find(trade.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should update account balance' do
      trade_account = Account.find(account.id)
      account_trades = trade_account.trades.sum(:result_balance)
      expect(trade_account.current_balance).to eq(account.current_balance + account_trades)
    end
  end
end
