require "rails_helper"

RSpec.describe GroupNgCondition, type: :model do
  describe "関連付け" do
    it "groupに属する" do
      association = described_class.reflect_on_association(:group)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("Group")
      expect(association.foreign_key).to eq("group_id")
    end
  end
end
