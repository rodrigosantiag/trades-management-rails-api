require 'rails_helper'

RSpec.describe 'Trade API', type: :request do
  before {host! 'api.binaryoptionsmanagement.local'}
  let!(:user) {create(:user)}
  let!(:auth_data) {user.create_new_auth_token}
  let!(:account) {create(:account, user_id: user.id)}
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
        create_list(:trade, 10, account_id: account.id, user_id: user.id)
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
      let!(:trade1) {create(:trade, account_id: account.id, user_id: user.id)}
      let!(:trade2) {create(:trade, account_id: account2.id, user_id: user.id)}
      let!(:trade3) {create(:trade, account_id: account.id, user_id: user.id)}
      let!(:trade4) {create(:trade, account_id: account2.id, user_id: user.id)}
      before do
        get "/trades?q[account_id_eq]=#{account.id}", params: {}, headers: headers
      end

      it 'should return only account\'s trades' do
        trades = json_body[:data].map {|trade| trade[:attributes][:'account-id'].to_i}

        expect(trades).to eq([trade1.account_id, trade3.account_id])
      end
    end

  end
end
