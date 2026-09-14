class AddNicknameToGroupMembers < ActiveRecord::Migration[7.2]
  def change
    add_column :group_members, :nickname, :string
    add_index :group_members, [:group_id, :nickname], unique: true
  end
end
