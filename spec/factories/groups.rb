FactoryBot.define do
  factory :group do
    creator_id { "" }
    name { "MyString" }
    budget { 1 }
    invite_token { "MyString" }
    decided_restaurant_id { "" }
  end
end
