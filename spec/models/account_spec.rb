require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) {build(:account)}

  it {is_expected.to belong_to(:broker)}

  it {is_expected.to validate_presence_of(:type)}
  it {is_expected.to validate_presence_of(:currency)}
  it {is_expected.to validate_presence_of(:initial_balance)}
  it {is_expected.to validate_presence_of(:current_balance)}

  it {is_expected.to respond_to(:type)}
  it {is_expected.to respond_to(:currency)}
  it {is_expected.to respond_to(:current_balance)}
  it {is_expected.to respond_to(:initial_balance)}

end
