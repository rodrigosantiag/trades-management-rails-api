# frozen_string_literal: true

# Strategy object represents a strategy used in trading analysis. This strategy is created by users and it represents
# user's personal analysis to take, or not, a trade
class Strategy < ApplicationRecord
  belongs_to :user
  has_many :trades, dependent: :nullify

  validates :name, presence: true
end
