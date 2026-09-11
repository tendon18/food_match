class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password_confirmation
  validates :password, confirmation: true
end
