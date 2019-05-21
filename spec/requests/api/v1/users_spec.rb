require 'rails_helper'

RSpec.describe 'Users API', type: :request do
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

  before {host! 'api.binaryoptionsmanagement.local'}

  describe 'GET /auth/validate_token' do
    context 'when the request headers are valid' do
      before do
        get '/auth/validate_token', params: {}, headers: headers
      end

      it 'should return user id' do
        expect(json_body[:data][:id].to_i).to eq(user.id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when request headers are invalid' do
      before do
        headers['access-token'] = 'invalid-token'
        get '/auth/validate_token', params: {}, headers: headers
      end

      it 'should return status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /auth' do
    before do
      post '/auth', params: user_params.to_json, headers: headers
    end

    context 'when request params are valid' do
      let(:user_params) {attributes_for(:user)}

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should return user attributes as json data' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) {attributes_for(:user, email: 'invalid_email@')}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /auth' do
    before do
      put '/auth', params: user_params.to_json, headers: headers
    end

    context 'when user params are valid' do
      let(:user_params) {{email: 'new@email.com', name: 'John Doe', risk: 10}}

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should reutrn updated user' do
        expect(json_body[:data][:name]).to eq(user_params[:name])
        expect(json_body[:data][:email]).to eq(user_params[:email])
        expect(json_body[:data][:risk]).to eq(user_params[:risk])
      end
    end
    
    context 'when user params are invalid' do
      let(:user_params) {{email: 'new@invalid'}}

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return key errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /auth' do
    before do
      delete '/auth', params: {}, headers: headers
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'should remove user from database' do
      expect(User.find_by(id: user.id)).to be_nil
    end
  end

  describe 'PUT /auth/password' do
    before do
      put '/auth/password', params: user_params.to_json, headers: headers
    end

    context 'when password is updated successfuly' do
      let(:user_params) {{password: 'abc12345', password_confirmation: 'abc12345'}}

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should have success key' do
        expect(json_body).to have_key(:success)
      end
    end

    context 'when password and password confirmation do not match' do
      let(:user_params) {{password: 'abs1235', password_confirmation: '8945u3084'}}

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should have key errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
end
