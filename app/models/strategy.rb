class Strategy < ApplicationRecord
  belongs_to :user
  has_many :trades, dependent: :nullify

  validates_presence_of :name
end
