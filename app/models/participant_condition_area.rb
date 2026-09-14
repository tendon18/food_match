class ParticipantConditionArea < ApplicationRecord
  belongs_to :participant_condition
  belongs_to :group_area
end
