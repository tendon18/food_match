class CreateGroupGenres < ActiveRecord::Migration[7.2]
  def change
    create_table :group_genres do |t|
      t.bigint :group_id
      t.string :genre

      t.timestamps
    end
  end
end
