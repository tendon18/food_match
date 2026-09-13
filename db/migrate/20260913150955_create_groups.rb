class CreateGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :groups do |t|
      t.bigint :creator_id
      t.string :name
      t.integer :budget
      t.string :invite_token
      t.bigint :decided_restaurant_id

      t.timestamps
    end
  end
end
