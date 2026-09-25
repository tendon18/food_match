class AddRestaurantSubmissionCompletedToGroupMembers < ActiveRecord::Migration[7.2]
  def change
    add_column :group_members,
               :restaurant_submission_completed,
               :boolean,
               default: false,
               null: false
  end
end
