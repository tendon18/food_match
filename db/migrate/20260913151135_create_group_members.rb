class CreateGroupMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :group_members do |t|
      t.bigint :group_id
      t.bigint :user_id
      t.string :role

      t.timestamps
    end
  end
end
