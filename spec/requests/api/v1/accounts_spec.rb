require 'rails_helper'

RSpec.describe 'Account API', type: :request do
  before {host! 'api.binaryoptionsmanagement.local'}
  let!(:user) {create(:user)}
  let!(:auth_data) {user.create_new_auth_token}
  let(:headers) do
    {
        'Accept' => 'application/vnd.binaryoptionsmanagement.v1',
        'Content-Type' => Mime[:json].to_s,
        'access-token' => auth_data['access-token'],
        'uid' => auth_data['uid'],
        'client' => auth_data['client']
    }
  end
  let!(:broker) {create(:broker, user_id: user.id)}

  describe 'GET /accounts' do

    context 'when params are not passed' do
      before do
        create_list(:account, 2, broker_id: broker.id, user_id: user.id)
        get '/accounts', params: {}, headers: headers
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should return a list of broker accounts from database' do
        # accounts = json_body[:data].map {|account| account[:relationships][:accounts][:data]}
        expect(json_body[:data].count).to eq(2)
      end
    end


    context 'when params are passed' do
      let!(:account_1) {create(:account, broker_id: broker.id, user_id: user.id)}
      let!(:account_2) {create(:account, broker_id: broker.id, user_id: user.id)}
      let!(:broker2) {create(:broker, user_id: user.id)}
      let!(:account_3) {create(:account, broker_id: broker2.id, user_id: user.id)}
      let!(:account_4) {create(:account, broker_id: broker2.id, user_id: user.id)}
      before do
        get "/accounts?q[broker_id_eq]=#{broker.id}", params: {}, headers: headers
      end

      it 'should return the accounts for broker' do
        accounts = json_body[:data].map {|account| account[:attributes][:"broker-id"].to_i}

        expect(accounts).to eq([account_1.broker_id, account_2.broker_id])
      end
    end
  end

  describe 'GET /accounts/:id' do
    let(:account) {create(:account, user_id: user.id, broker_id: broker.id)}

    before do
      get "/accounts/#{account.id}", params: {}, headers: headers
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'should return data for account' do
      expect(json_body[:data][:attributes][:currency]).to eq(account.currency)
    end
  end

  describe 'POST /accounts' do
    before do
      post '/accounts', params: {account: account_params}.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:account_params) {attributes_for(:account, broker_id: broker.id)}

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'should save new account on database' do
        expect(Account.find_by(type_account: account_params[:type_account])).not_to be_nil
      end

      it 'should return data for the new account' do
        expect(json_body[:data][:attributes][:'type-account']).to eq(account_params[:type_account])
      end

      it 'should associate account to broker' do
        expect(json_body[:data][:attributes][:'broker-id']).to eq(broker.id)
      end

      it 'should associate account to user' do
        expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
      end
    end

    context 'when params are invalid' do
      let(:account_params) {attributes_for(:account, currency: nil)}

      it 'should return status 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return errors' do
        expect(json_body).to have_key(:errors)
      end

      it 'should not save account on database' do
        expect(Account.find_by(type_account: account_params[:type_account])).to be_nil
      end
    end
  end

  describe 'PUT /accounts/:id' do
    let!(:account) {create(:account, user_id: user.id, broker_id: broker.id)}

    before do
      put "/accounts/#{account.id}", params: {account: account_params}.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:account_params) {{currency: 'BRL'}}
      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should should return updated account data' do
        expect(json_body[:data][:attributes][:currency]).not_to be_nil
      end

      it 'should save updated account to database' do
        saved_account = Account.find(account.id)
        expect(saved_account.currency).to eq(account_params[:currency])
      end
    end

    context 'when params are invalid' do
      let(:account_params) {{currency: ' '}}

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return errors' do
        expect(json_body).to have_key(:errors)
      end

      it 'should not save the update on database' do
        account_updated = Account.find(account.id)
        expect(account_updated.currency).not_to eq(account_params[:currency])
      end
    end
  end
end
