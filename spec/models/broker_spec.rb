require 'rails_helper'

RSpec.describe Broker, type: :model do
  let(:broker) {build(:broker)}

  it {is_expected.to belong_to(:user)}

  it {is_expected.to validate_presence_of(:name)}
  it {is_expected.to validate_presence_of(:user)}
  it {is_expected.to respond_to(:name)}
  it {is_expected.to respond_to(:user)}
end
