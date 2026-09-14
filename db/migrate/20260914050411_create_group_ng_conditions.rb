class CreateGroupNgConditions < ActiveRecord::Migration[7.2]
  def change
    create_table :group_ng_conditions do |t|
      t.references :group, null: false, foreign_key: true
      t.string :condition
      t.string :status

      t.timestamps
    end
  end
end
