# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User API' do
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

  before { host! 'api.binaryoptionsmanagement.local' }

  describe 'GET /auth/validate_token' do
    context 'when the request headers are valid' do
      before do
        get '/auth/validate_token', params: {}, headers:
      end

      it 'return user id' do
        expect(json_body[:data][:id].to_i).to eq(user.id)
      end

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when request headers are invalid' do
      before do
        headers['access-token'] = 'invalid-token'
        get '/auth/validate_token', params: {}, headers:
      end

      it 'return status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /auth' do
    before do
      post '/auth', params: user_params.to_json, headers:
    end

    context 'when request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return user attributes as json data' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid_email@') }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /auth' do
    before do
      put '/auth', params: user_params.to_json, headers:
    end

    context 'when user params are valid' do
      let(:user_params) { { email: 'new@email.com', name: 'John Doe', risk: 10 } }

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'reutrn updated user' do
        expect(json_body[:data][:name]).to eq(user_params[:name])
        expect(json_body[:data][:email]).to eq(user_params[:email])
        expect(json_body[:data][:risk]).to eq(user_params[:risk])
      end
    end

    context 'when user params are invalid' do
      let(:user_params) { { email: 'new@invalid' } }

      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return key errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /auth' do
    before do
      delete '/auth', params: {}, headers:
    end

    it 'return status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'remove user from database' do
      expect(User.find_by(id: user.id)).to be_nil
    end
  end

  describe 'PUT /auth/password' do
    before do
      put '/auth/password', params: user_params.to_json, headers:
    end

    context 'when password is updated successfuly' do
      let(:user_params) { { password: 'abc12345', password_confirmation: 'abc12345' } }

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'have success key' do
        expect(json_body).to have_key(:success)
      end
    end

    context 'when password and password confirmation do not match' do
      let(:user_params) { { password: 'abs1235', password_confirmation: '8945u3084' } }

      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'have key errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'GET /users/:id' do
    context 'when user is valid' do
      before { get "/users/#{user.id}", params: {}, headers: }

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return user data' do
        expect(json_body[:data][:attributes][:name]).to eq(user.name)
      end
    end
  end

  describe 'PUT /reset_password/:reset_token_password' do
    let!(:old_password) { user.encrypted_password }

    let!(:user_params) do
      {
        reset_password_token: 'foo-bar',
        password: '87654321',
        password_confirmation: '87654321'
      }
    end

    context 'when token is valid' do
      before do
        user.update(reset_password_token: '2ba85a8a179102f5191d37e0733b647cd011aba80e9fd198f4d2cd0c5c892a6c')
        put '/reset_password/2ba85a8a179102f5191d37e0733b647cd011aba80e9fd198f4d2cd0c5c892a6c',
            params: user_params.to_json, headers:
      end

      it 'return statud code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return user data' do
        expect(json_body[:data][:attributes][:name]).to eq(user.name)
      end

      it 'updates user passowrd' do
        expect(user.reload.encrypted_password).not_to eq(old_password)
      end
    end

    context 'when token is invalid' do
      before { put '/reset_password/foo-bar', params: user_params.to_json, headers: }

      it 'return status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'return error message' do
        expect(json_body[:errors][0]).to eq('User not found or token expired/already used')
      end
    end
  end

  describe 'PUT /users/:id' do
    let!(:other_user) { create(:user) }

    let!(:user_params) do
      {
        name: 'John Doe',
        risk: 10
      }
    end

    context 'when user tries to update another user' do
      before { put "/users/#{other_user.id}", params: user_params.to_json, headers: }

      it 'return status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'return error message' do
        expect(json_body[:errors][0]).to eq('You are not allowed to edit this user')
      end
    end

    context 'when user tries to update himself with valid data' do
      before { put "/users/#{user.id}", params: user_params.to_json, headers: }

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'update user data' do
        expect(user.reload.name).to eq('John Doe')
        expect(user.reload.risk).to eq(10)
      end

      it 'render user info' do
        expect(json_body[:data][:attributes][:name]).to eq('John Doe')
      end
    end

    context 'when user tries to update himself with invalid data' do
      before do
        user_params[:name] = nil
        put "/users/#{user.id}", params: user_params.to_json, headers:
      end

      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'do not update user data' do
        expect(user.reload.name).not_to eq('John Doe')
        expect(user.reload.risk).not_to eq(10)
      end

      it 'render user info' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
end
