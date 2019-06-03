class AccountSerializer < ActiveModel::Serializer
  attributes :id, :type_account, :currency, :initial_balance, :current_balance, :broker_id

  belongs_to :broker
  belongs_to :user
end
