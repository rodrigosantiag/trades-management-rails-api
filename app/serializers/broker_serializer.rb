class BrokerSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id

  belongs_to :user

  has_many :accounts, dependent: :destroy
end
