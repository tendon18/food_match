require "rails_helper"

RSpec.describe User, type: :model do
  describe "関連付け" do
    it "作成したGroupを持つ" do
      association = described_class.reflect_on_association(:created_groups)

      expect(association.macro).to eq(:has_many)
      expect(association.class_name).to eq("Group")
      expect(association.foreign_key).to eq("creator_id")
    end

    it "GroupMemberを複数持つ" do
      association = described_class.reflect_on_association(:group_members)

      expect(association.macro).to eq(:has_many)
      expect(association.class_name).to eq("GroupMember")
    end

    it "参加しているGroupを持つ" do
      association = described_class.reflect_on_association(:groups)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:group_members)
    end
  end
end
