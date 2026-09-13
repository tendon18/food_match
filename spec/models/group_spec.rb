require "rails_helper"

RSpec.describe Group, type: :model do
  describe "関連付け" do
    it "creatorとしてUserを持つ" do
      association = described_class.reflect_on_association(:creator)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("User")
      expect(association.foreign_key).to eq("creator_id")
    end

    it "group_membersを複数持つ" do
      association = described_class.reflect_on_association(:group_members)

      expect(association.macro).to eq(:has_many)
      expect(association.class_name).to eq("GroupMember")
    end
  end

  describe "バリデーション" do
    it "グループ名が必須である" do
      group = Group.new(name: "")

      expect(group).not_to be_valid
      expect(group.errors[:name]).to include("can't be blank")
    end
  end
end
