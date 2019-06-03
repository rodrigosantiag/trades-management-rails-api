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
        create_list(:account, 2, broker_id: broker.id)
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
      let!(:account_1) {create(:account, broker_id: broker.id)}
      let!(:account_2) {create(:account, broker_id: broker.id)}
      let!(:broker2) {create(:broker, user_id: user.id)}
      let!(:account_3) {create(:account, broker_id: broker2.id)}
      let!(:account_4) {create(:account, broker_id: broker2.id)}
      before do
        get "/accounts?q[broker_id_eq]=#{broker.id}", params: {}, headers: headers
      end

      it 'should return the accounts for broker' do
        accounts = json_body[:data].map {|account| account[:attributes][:"broker-id"].to_i}

        expect(accounts).to eq([account_1.broker_id, account_2.broker_id])
      end
    end


  end
end
