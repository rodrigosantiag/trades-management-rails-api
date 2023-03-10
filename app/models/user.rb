# frozen_string_literal: true

# User object represents a trader on forex or binary options markets
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :brokers, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :trades, dependent: :destroy
  has_many :strategies, dependent: :destroy

  validates :name, presence: true
end
