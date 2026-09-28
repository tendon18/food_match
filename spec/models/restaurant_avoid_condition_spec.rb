require 'rails_helper'

RSpec.describe RestaurantAvoidCondition, type: :model do
  describe "関連付け" do
    it "restaurantに属する" do
      association = described_class.reflect_on_association(:restaurant)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("Restaurant")
    end

    it "group_avoid_conditionに属する" do
      association = described_class.reflect_on_association(:group_avoid_condition)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("GroupAvoidCondition")
    end
  end
end
