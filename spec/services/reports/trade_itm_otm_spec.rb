# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Trade ITM OTM Service' do
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
  let!(:account) { create(:account, user_id: user.id, broker_id: broker.id) }
  let!(:strategy) { create(:strategy, user_id: user.id) }

  context 'when account has 50/50 results' do
    let(:trade1) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: true) }
    let(:trade2) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: true) }
    let(:trade3) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: false) }
    let(:trade4) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: false) }

    let(:result) { Reports::TradeItmOtm.new([trade1, trade2, trade3, trade4]).call }

    it { expect(result[:itm]).to eq(50) }

    it { expect(result[:otm]).to eq(50) }
  end

  context 'when account has 60/40 results' do
    let(:trade1) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: true) }
    let(:trade2) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: true) }
    let(:trade3) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: false) }
    let(:trade4) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: false) }
    let(:trade5) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: true) }
    let(:trade6) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: true) }
    let(:trade7) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: false) }
    let(:trade8) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: true) }
    let(:trade9) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: false) }
    let(:trade10) { create(:trade, strategy_id: strategy.id, account_id: account.id, result: true) }

    let(:result) do
      Reports::TradeItmOtm.new([trade1, trade2, trade3, trade4, trade5, trade6, trade7, trade8,
                                trade9, trade10]).call
    end

    it { expect(result[:itm]).to eq(60) }

    it { expect(result[:otm]).to eq(40) }
  end
end
