require 'rails_helper'

RSpec.describe 'Strategy API', type: :request do
  before { host! 'api.binaryoptionsmanagement.local' }
  let!(:user) { create(:user) }
  let!(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
        'Accept' => 'application/vnd.binaryoptionsmanagement.v1',
        'Content-Type' => Mime[:json].to_s,
        'access-token' => auth_data['access-token'],
        'uid' => auth_data['uid'],
        'client' => auth_data['client']
    }
  end

  describe 'GET /strategies' do
    context 'Random strategies list. Check responser' do
      before do
        create_list(:strategy, 10, user_id: user.id)
        get '/strategies', params: {}, headers: headers
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should return a list of strategies from database' do
        expect(json_body[:data].count).to eq(10)
      end
    end

    context 'Return list of strategies in alphabetical order' do
      let!(:strategy1) { create(:strategy, name: 'Strategy B', user_id: user.id) }
      let!(:strategy2) { create(:strategy, name: 'Strategy A', user_id: user.id) }
      let!(:strategy3) { create(:strategy, name: 'Strategy C', user_id: user.id) }

      before do
        get '/strategies', params: {}, headers: headers
      end

      it 'should return ordered by name' do
        returned_strategies = json_body[:data].map {|s| s[:attributes][:name]}

        expect(returned_strategies).to eq([strategy2.name, strategy1.name, strategy3.name])
      end
    end
  end

  describe 'GET /strategies/:id' do
    let(:strategy) {create(:strategy, user_id: user.id)}

    before {get "/strategies/#{strategy.id}", params: {}, headers: headers}

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'should return strategy data' do
      expect(json_body[:data][:attributes][:name]).to eq(strategy.name)
    end
  end

  describe 'POST /strategies' do
    before do
      post '/strategies', params: {strategy: strategy_params}.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:strategy_params) {attributes_for(:strategy)}

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'should save the strategy in database' do
        expect(Strategy.find_by_name(strategy_params[:name])).not_to be_nil
      end

      it 'should return strategy data' do
        expect(json_body[:data][:attributes][:name]).to eq(strategy_params[:name])
      end

      it 'should assign stratey to user' do
        expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
      end
    end

    context 'when params are invalid' do
      let(:strategy_params) {attributes_for(:strategy, name: ' ')}

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should not save strategy in database' do
        expect(Strategy.find_by_name(strategy_params[:name])).to be_nil
      end

      it 'should return error key for name' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'PUT /strategies/:id' do
    let!(:strategy) {create(:strategy, user_id: user.id)}

    before do
      put "/strategies/#{strategy.id}", params: {strategy: strategy_params}.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:strategy_params) {{name: 'New strategy name'}}

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should save updated strategy in database' do
        expect(Strategy.find_by_name(strategy_params[:name])).not_to be_nil
      end

      it 'should return updated strategy data' do
        expect(json_body[:data][:attributes][:name]).to eq(strategy_params[:name])
      end
    end

    context 'when parameters are not valid' do
      let(:strategy_params) {{name: ' '}}

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should not save invalid strategy in database' do
        expect(Strategy.find_by_name(strategy_params[:name])).to be_nil
      end

      it 'should have key :name in errors' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'DELETE /strategies/:id' do
    let!(:strategy) { create(:strategy, user_id: user.id) }
    let!(:trade) {create(:trade, user_id: user.id, strategy_id: strategy.id)}

    before do
      delete "/strategies/#{strategy.id}", params: {}, headers: headers
    end

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'should remove strategy from database' do
      expect {Strategy.find(strategy.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should nullify trade strategy ID' do
      trade_after_strategy_deleted = Trade.find(trade.id)
      expect(trade_after_strategy_deleted.strategy_id).to be_nil
    end
  end

end
