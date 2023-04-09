# frozen_string_literal: true

class AddDurationToStrategies < ActiveRecord::Migration[7.0]
  def up
    add_column :strategies, :duration, :integer
  end

  def down
    remove_column :strategies, :duration
  end
end
