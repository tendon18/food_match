class Group < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :group_members
  has_many :group_genres
  has_many :group_areas
  has_many :group_avoid_conditions
  validates :name, presence: true

  before_create :generate_invite_token

  private

  def generate_invite_token
    self.invite_token = SecureRandom.hex(16)
  end
end
