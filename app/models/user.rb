class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password_confirmation
  validates :password, confirmation: true

  has_many :created_groups,
           class_name: "Group",
           foreign_key: "creator_id"
  has_many :group_members
  has_many :groups, through: :group_members
end
