class ParticipantConditionGenre < ApplicationRecord
  belongs_to :participant_condition
  belongs_to :group_genre
end
