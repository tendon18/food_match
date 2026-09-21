class GroupAvoidCondition < ApplicationRecord
  belongs_to :group
  has_many :restaurant_avoid_conditions
end
