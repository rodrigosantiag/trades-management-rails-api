class SerializableAccount < JSONAPI::Serializable::Resource
  type 'accounts'
  attribute :created_date_formatted do
    @object.created_at.strftime('%m/%d/%Y %H:%M:%S')
  end
  attribute :account_risk do
    @object.user.risk
  end
  attribute :type_account
  attribute :currency
  attribute :initial_balance
  attribute :current_balance
  attribute :created_at
  attribute :updated_at

  has_one :broker
  has_one :user
  has_many :trades do
    meta do
      { general_results: Reports::TradeItmOtm.new(@object.trades).call }
    end
  end
end
