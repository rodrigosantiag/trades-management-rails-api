# frozen_string_literal: true

require 'rails_helper'

describe 'TradeItmOtmMonthly' do
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

  context 'when trades created_at are in January, February and March' do
    let(:trade1) do
      create(:trade, account_id: account.id, strategy_id: strategy.id, user_id: user.id, result: true,
                     created_at: DateTime.new(2020, 1, 23, 0, 0, 0))
    end
    let(:trade2) do
      create(:trade, account_id: account.id, strategy_id: strategy.id, user_id: user.id, result: true,
                     created_at: DateTime.new(2020, 3, 25, 0, 0, 0))
    end
    let(:trade3) do
      create(:trade, account_id: account.id, strategy_id: strategy.id, user_id: user.id, result: false,
                     created_at: DateTime.new(2020, 2, 1, 0, 0, 0))
    end
    let(:trade4) do
      create(:trade, account_id: account.id, strategy_id: strategy.id, user_id: user.id, result: false,
                     created_at: DateTime.new(2020, 1, 5, 0, 0, 0))
    end


    let!(:result) { Reports::TradeItmOtmMonthly.new([trade1, trade2, trade3, trade4]).call }


    it { expect(result).to have_key('01/2020') }

    it { expect(result).to have_key('02/2020') }

    it { expect(result).to have_key('03/2020') }

    it { expect(result['01/2020'][:itm]).to eq(50) }
    it { expect(result['01/2020'][:otm]).to eq(50) }

    it { expect(result['02/2020'][:itm]).to eq(0) }
    it { expect(result['02/2020'][:otm]).to eq(100) }

    it { expect(result['03/2020'][:itm]).to eq(100) }
    it { expect(result['03/2020'][:otm]).to eq(0) }
  end
end
