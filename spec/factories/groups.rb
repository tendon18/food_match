FactoryBot.define do
  factory :group do
    association :creator, factory: :user
    name { "テストグループ" }
    budget { 1 }
    invite_token { "test-token" }
    decided_restaurant_id { nil }
  end
end
