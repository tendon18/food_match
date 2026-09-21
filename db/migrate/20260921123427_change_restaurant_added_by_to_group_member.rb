class ChangeRestaurantAddedByToGroupMember < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :restaurants, :users

    execute <<~SQL
      UPDATE restaurants
      SET added_by_id = group_members.id
      FROM group_members
      WHERE restaurants.added_by_id = group_members.user_id
        AND restaurants.group_id = group_members.group_id
    SQL

    add_foreign_key :restaurants, :group_members, column: :added_by_id
  end
end
