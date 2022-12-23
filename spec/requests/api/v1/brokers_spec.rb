# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Broker API' do
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

  describe 'GET /brokers' do
    context 'random list. Checking responses' do
      before do
        create_list(:broker, 3, user_id: user.id)
        get '/brokers', params: {}, headers:
      end

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return list of brokers from database' do
        expect(json_body[:data].count).to eq(3)
      end
    end

    context 'return in alphabetical order' do
      let!(:broker1) { create(:broker, name: 'IQ Option', user_id: user.id) }
      let!(:broker2) { create(:broker, name: 'Binary.com', user_id: user.id) }
      let!(:broker3) { create(:broker, name: 'Binomo Torneios', user_id: user.id) }

      before do
        get '/brokers', params: {}, headers:
      end

      it 'return ordered by name' do
        returned_brokers = json_body[:data].map { |t| t[:attributes][:name] }

        expect(returned_brokers).to eq([broker2.name, broker3.name, broker1.name])
      end
    end
  end

  describe 'GET /brokers/:id' do
    let(:broker) { create(:broker, user_id: user.id) }

    before { get "/brokers/#{broker.id}", params: {}, headers: }

    it 'return status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'return broker data' do
      expect(json_body[:data][:attributes][:name]).to eq(broker.name)
    end
  end

  describe 'POST /brokers' do
    before do
      post '/brokers', params: { broker: broker_params }.to_json, headers:
    end

    context 'when params are valid' do
      let(:broker_params) { attributes_for(:broker) }

      it 'return status code 201' do
        expect(response).to have_http_status(:created)
      end

      it 'save the broker in database' do
        expect(Broker.find_by(name: broker_params[:name])).not_to be_nil
      end

      it 'return the broker data' do
        expect(json_body[:data][:attributes][:name]).to eq(broker_params[:name])
      end

      it 'assign the broker to the user' do
        expect(json_body[:data]).to have_relationship(:user)
      end
    end

    context 'when params are not valid' do
      let(:broker_params) { attributes_for(:broker, name: ' ') }

      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'not save broker in database' do
        expect(Broker.find_by(name: broker_params[:name])).to be_nil
      end

      it 'return errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /brokers/:id' do
    let!(:broker) { create(:broker, user_id: user.id) }

    before do
      put "/brokers/#{broker.id}", params: { broker: broker_params }.to_json, headers:
    end

    context 'when params are valid' do
      let(:broker_params) { { name: 'New Broker Name' } }

      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'save broker updated on database' do
        expect(Broker.find_by(name: broker_params[:name])).not_to be_nil
      end

      it 'return updated broker' do
        expect(json_body[:data][:attributes][:name]).to eq(broker_params[:name])
      end
    end

    context 'when params are not valid' do
      let(:broker_params) { { name: ' ' } }

      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'not save invalid broker in database' do
        expect(Broker.find_by(name: broker_params[:name])).to be_nil
      end

      it 'return errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /brokers/:id' do
    let!(:broker) { create(:broker, user_id: user.id) }

    before do
      delete "/brokers/#{broker.id}", params: {}, headers:
    end

    it 'return status code 204' do
      expect(response).to have_http_status(:no_content)
    end

    it 'remove broker from database' do
      expect { Broker.find(broker.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
