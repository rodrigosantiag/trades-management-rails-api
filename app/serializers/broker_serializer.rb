class BrokerSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :accounts

  belongs_to :user

  has_many :accounts, dependent: :destroy

  def accounts
    object.accounts.map do |account|
      ::AccountSerializer.new(account).attributes
    end
  end
end
