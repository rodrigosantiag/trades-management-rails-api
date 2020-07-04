class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :risk, :email

  has_many :brokers, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :trades, dependent: :destroy
  has_many :strategies, dependent: :destroy
end
