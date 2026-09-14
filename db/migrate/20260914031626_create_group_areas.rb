class CreateGroupAreas < ActiveRecord::Migration[7.2]
  def change
    create_table :group_areas do |t|
      t.references :group, null: false, foreign_key: true
      t.string :area

      t.timestamps
    end
  end
end
