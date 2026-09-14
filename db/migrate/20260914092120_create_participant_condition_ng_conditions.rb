class CreateParticipantConditionNgConditions < ActiveRecord::Migration[7.2]
  def change
    create_table :participant_condition_ng_conditions do |t|
      t.references :participant_condition, null: false, foreign_key: true
      t.references :group_ng_condition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
