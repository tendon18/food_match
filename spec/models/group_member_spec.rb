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

  describe "#organizer?" do
    it "roleがorganizerならtrueを返す" do
      group_member = build(:group_member, role: "organizer")

      expect(group_member.organizer?).to be true
    end

    it "roleがorganizer以外ならfalseを返す" do
      group_member = build(:group_member, role: "member")

      expect(group_member.organizer?).to be false
    end
  end

  describe "バリデーション" do
    it "nicknameがあれば有効" do
      group_member = build(:group_member)

      expect(group_member).to be_valid
    end

    it "nicknameがなければ無効" do
      group_member = build(:group_member, nickname: nil)

      expect(group_member).to be_invalid
    end
  end
end
