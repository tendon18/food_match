class GroupArea < ApplicationRecord
  belongs_to :group
  has_many :restaurants

  validates :area, presence: true
end
