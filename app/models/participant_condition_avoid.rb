class ParticipantConditionAvoid < ApplicationRecord
  belongs_to :participant_condition
  belongs_to :group_avoid_condition
end
