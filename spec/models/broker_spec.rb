require 'rails_helper'

RSpec.describe Broker, type: :model do
  let(:task) {build(:task)}

  it {is_expected.to belong_to(:user)}

  context 'when is new' do
    it {expect(:name).not_to be_nil}
  end

  it {is_expected.to validate_presence_of(:name)}
  it {is_expected.to respond_to(:name)}
  it {is_expected.to respond_to(:user_id)}
end
