class CreateParticipantConditionGenres < ActiveRecord::Migration[7.2]
  def change
    create_table :participant_condition_genres do |t|
      t.references :participant_condition, null: false, foreign_key: true
      t.references :group_genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
