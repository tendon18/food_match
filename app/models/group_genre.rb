class GroupGenre < ApplicationRecord
  belongs_to :group

  validates :genre, presence: true
end
