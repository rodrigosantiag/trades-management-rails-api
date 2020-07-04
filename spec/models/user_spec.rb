require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {build(:user)}

  it {is_expected.to have_many(:brokers).dependent(:destroy)}
  it {is_expected.to have_many(:accounts).dependent(:destroy)}
  it {is_expected.to have_many(:trades).dependent(:destroy)}
  it {is_expected.to have_many(:strategies).dependent(:destroy)}

  it {is_expected.to validate_presence_of(:name)}
  it {is_expected.to validate_presence_of(:email)}
  it {expect(create(:user)).to validate_uniqueness_of(:email).case_insensitive.scoped_to(:provider)}
  it {is_expected.to validate_confirmation_of(:password)}
  it {is_expected.to allow_value('rodrigosantiag@gmail.com').for(:email)}

end
