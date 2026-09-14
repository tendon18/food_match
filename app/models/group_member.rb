class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :user, optional: true

  def organizer?
    role == "organizer"
  end
end
