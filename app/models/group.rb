class Group < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :group_members

  validates :name, presence: true
end
