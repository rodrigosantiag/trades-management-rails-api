class Strategy < ApplicationRecord
  belongs_to :user
  has_many :trades

  validates_presence_of :name
end
