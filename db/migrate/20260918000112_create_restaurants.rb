class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.references :group, null: false, foreign_key: true
      t.references :added_by, null: false, foreign_key: { to_table: :users }
      t.references :group_genre, null: false, foreign_key: true
      t.references :group_area, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :budget, null: false
      t.string :features
      t.string :url
      t.text :memo

      t.timestamps
    end
  end
end
