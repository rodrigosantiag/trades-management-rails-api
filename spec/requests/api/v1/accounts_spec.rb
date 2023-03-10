# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Account API' do
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
  let!(:broker) { create(:broker, user_id: user.id) }

  describe 'GET /accounts' do
    context 'when params are not passed' do
      before do
        create_list(:account, 2, broker_id: broker.id, user_id: user.id)
        get '/accounts', params: {}, headers:
      end

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return a list of broker accounts from database' do
        expect(json_body[:data].count).to eq(2)
      end
    end

    context 'when params are passed' do
      let!(:account_1) { create(:account, broker_id: broker.id, user_id: user.id) }
      let!(:account_2) { create(:account, broker_id: broker.id, user_id: user.id) }

      before do
        get "/accounts?q[broker_id_eq]=#{broker.id}", params: {}, headers:
      end

      it 'return the accounts for broker' do
        accounts = json_body[:data].map { |account| account[:id].to_i }

        expect(accounts).to eq([account_1.id, account_2.id])
      end
    end
  end

  describe 'GET /accounts/:id' do
    let(:account) { create(:account, user_id: user.id, broker_id: broker.id) }

    before do
      get "/accounts/#{account.id}", params: {}, headers:
    end

    it 'return status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'return data for account' do
      expect(json_body[:data][:attributes][:currency]).to eq(account.currency)
    end
  end

  describe 'POST /accounts' do
    before do
      post '/accounts', params: { account: account_params }.to_json, headers:
    end

    context 'when params are valid' do
      let(:account_params) { attributes_for(:account, broker_id: broker.id) }

      it 'return status code 201' do
        expect(response).to have_http_status(:created)
      end

      it 'save new account on database' do
        expect(Account.find_by(type_account: account_params[:type_account])).not_to be_nil
      end

      it 'return data for the new account' do
        expect(json_body[:data][:attributes][:type_account]).to eq(account_params[:type_account])
      end

      it 'associate account to broker and user' do
        expect(json_body[:data]).to have_relationships(:broker, :user)
      end
    end

    context 'when params are invalid' do
      let(:account_params) { attributes_for(:account, currency: nil) }

      it 'return status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return errors' do
        expect(json_body).to have_key(:errors)
      end

      it 'not save account on database' do
        expect(Account.find_by(type_account: account_params[:type_account])).to be_nil
      end
    end
  end

  describe 'PUT /accounts/:id' do
    let!(:account) { create(:account, user_id: user.id, broker_id: broker.id) }

    before do
      put "/accounts/#{account.id}", params: { account: account_params }.to_json, headers:
    end

    context 'when params are valid' do
      let(:account_params) { { currency: 'BRL' } }

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return updated account data' do
        expect(json_body[:data][:attributes][:currency]).not_to be_nil
      end

      it 'save updated account to database' do
        saved_account = Account.find(account.id)
        expect(saved_account.currency).to eq(account_params[:currency])
      end
    end

    context 'when params are invalid' do
      let(:account_params) { { currency: ' ' } }

      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return errors' do
        expect(json_body).to have_key(:errors)
      end

      it 'not save the update on database' do
        account_updated = Account.find(account.id)
        expect(account_updated.currency).not_to eq(account_params[:currency])
      end
    end
  end

  describe 'DELETE /accounts/:id' do
    let(:account) { create(:account, user_id: user.id, broker_id: broker.id) }

    before do
      delete "/accounts/#{account.id}", params: {}, headers:
    end

    it 'return status 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'delete account from database' do
      expect { Account.find(account.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
