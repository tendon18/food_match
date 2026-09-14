FactoryBot.define do
  factory :group_genre do
    association :group
    genre { "和食" }
  end
end
