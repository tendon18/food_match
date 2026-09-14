class ParticipantCondition < ApplicationRecord
  belongs_to :group_member

  has_many :participant_condition_genres
  has_many :group_genres, through: :participant_condition_genres

  has_many :participant_condition_areas
  has_many :group_areas, through: :participant_condition_areas

  has_many :participant_condition_avoids
  has_many :group_avoid_conditions, through: :participant_condition_avoids
end
