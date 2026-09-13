require "rails_helper"

RSpec.describe GroupMember, type: :model do
  describe "関連付け" do
    it "Groupを持つ" do
      association = described_class.reflect_on_association(:group)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("Group")
      expect(association.foreign_key).to eq("group_id")
    end

    it "Userを持つ" do
      association = described_class.reflect_on_association(:user)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("User")
      expect(association.foreign_key).to eq("user_id")
    end
  end
end
