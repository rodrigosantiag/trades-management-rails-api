require 'rails_helper'

RSpec.describe Trade, type: :model do
  let(:trade) {build(:trade)}

  it {is_expected.to belong_to(:account)}
  it {is_expected.to belong_to(:user)}

  it {is_expected.to validate_presence_of(:value)}
  it {is_expected.to validate_presence_of(:profit)}

  it {is_expected.to respond_to(:value)}
  it {is_expected.to respond_to(:profit)}
  it {is_expected.to respond_to(:result)}
  it {is_expected.to respond_to(:result_balance)}
  it {is_expected.to respond_to(:type_trade)}
end
