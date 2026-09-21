class Restaurant < ApplicationRecord
  belongs_to :group
  belongs_to :added_by, class_name: "GroupMember"
  belongs_to :group_genre
  belongs_to :group_area
  has_many :restaurant_avoid_conditions
end
