class CreateRestaurantAvoidConditions < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurant_avoid_conditions do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.references :group_avoid_condition, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
