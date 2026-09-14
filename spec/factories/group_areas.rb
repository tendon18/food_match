FactoryBot.define do
  factory :group_area do
    association :group
    area { "新宿" }
  end
end
