class CreateStrategies < ActiveRecord::Migration[6.0]
  def change
    create_table :strategies do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true, type: :integer

      t.timestamps
    end
  end
end
