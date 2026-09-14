class RenameParticipantConditionNgConditionsToParticipantConditionAvoids < ActiveRecord::Migration[7.2]
  def change
    rename_table :participant_condition_ng_conditions, :participant_condition_avoids

    rename_column :participant_condition_avoids,
                  :group_ng_condition_id,
                  :group_avoid_condition_id
  end
end
