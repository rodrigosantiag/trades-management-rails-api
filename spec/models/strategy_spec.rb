require 'rails_helper'

RSpec.describe Strategy, type: :model do
  let(:strategy) {build(:strategy)}

  it {is_expected.to belong_to(:user)}
  it {is_expected.to have_many(:trades)}

  it {is_expected.to validate_presence_of(:name)}

  it {is_expected.to respond_to(:name)}
end
