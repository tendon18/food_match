class AddUniqueIndexToParticipantConditionAvoids < ActiveRecord::Migration[7.2]
  def change
    add_index :participant_condition_avoids,
              [:participant_condition_id, :group_avoid_condition_id],
              unique: true
  end
end
