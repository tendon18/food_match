class Group < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :group_members
  has_many :group_genres
  has_many :group_areas
  has_many :group_ng_conditions
  validates :name, presence: true
end
