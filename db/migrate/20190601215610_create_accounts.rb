class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :type, limit: 1
      t.string :currency, limit: 3
      t.float :initial_balance
      t.float :current_balance
      t.references :broker, foreign_key: true

      t.timestamps
    end
  end
end
