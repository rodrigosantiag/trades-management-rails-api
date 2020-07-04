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
  end

#  TODO: implement test for alphabetical order strategy
end
