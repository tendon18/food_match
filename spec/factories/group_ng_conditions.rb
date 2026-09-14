FactoryBot.define do
  factory :group_ng_condition do
    association :group
    condition { "spicy" }
    status { "avoid" }
  end
end
