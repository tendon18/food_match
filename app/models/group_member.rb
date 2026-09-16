class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :user, optional: true

  has_one :participant_condition

  validates :nickname, presence: true

  def organizer?
    role == "organizer"
  end
end
