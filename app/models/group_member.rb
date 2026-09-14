class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :user, optional: true

  has_one :participant_condition

  def organizer?
    role == "organizer"
  end
end
