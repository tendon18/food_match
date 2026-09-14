class GroupArea < ApplicationRecord
  belongs_to :group

  validates :area, presence: true
end
