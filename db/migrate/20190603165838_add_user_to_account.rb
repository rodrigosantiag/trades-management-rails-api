# frozen_string_literal: true

class AddUserToAccount < ActiveRecord::Migration[5.0]
  def change
    add_reference :accounts, :user, foreign_key: true
  end
end
