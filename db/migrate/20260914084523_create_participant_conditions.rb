class CreateParticipantConditions < ActiveRecord::Migration[7.2]
  def change
    create_table :participant_conditions do |t|
      t.references :group_member, null: false, foreign_key: true
      t.integer :budget

      t.timestamps
    end
  end
end
