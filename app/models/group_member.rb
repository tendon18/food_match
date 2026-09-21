class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :user, optional: true

  has_one :participant_condition
  has_many :restaurants, foreign_key: :added_by_id

  validates :nickname, presence: true

  def organizer?
    role == "organizer"
  end
end
