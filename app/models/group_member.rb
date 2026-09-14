class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :user

  def organizer?
    role == "organizer"
  end
end
