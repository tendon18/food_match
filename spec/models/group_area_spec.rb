require "rails_helper"

RSpec.describe GroupArea, type: :model do
  describe "関連付け" do
    it "Groupを持つ" do
      association = described_class.reflect_on_association(:group)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("Group")
      expect(association.foreign_key).to eq("group_id")
    end
  end

  describe "バリデーション" do
    it "areaがあれば有効" do
      group_area = build(:group_area)

      expect(group_area).to be_valid
    end

    it "areaがなければ無効" do
      group_area = build(:group_area, area: nil)

      expect(group_area).to be_invalid
    end
  end
end
