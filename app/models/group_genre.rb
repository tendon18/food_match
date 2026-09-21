class GroupGenre < ApplicationRecord
  belongs_to :group
  has_many :restaurants

  validates :genre, presence: true
end
