class RestaurantAvoidCondition < ApplicationRecord
  belongs_to :restaurant
  belongs_to :group_avoid_condition
end
