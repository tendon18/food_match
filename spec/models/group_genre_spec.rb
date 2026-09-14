require "rails_helper"

RSpec.describe GroupGenre, type: :model do
  describe "関連付け" do
    it "Groupを持つ" do
      association = described_class.reflect_on_association(:group)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("Group")
      expect(association.foreign_key).to eq("group_id")
    end
  end

  describe "バリデーション" do
    it "genreがあれば有効" do
      group_genre = build(:group_genre)

      expect(group_genre).to be_valid
    end

    it "genreがなければ無効" do
      group_genre = build(:group_genre, genre: nil)

      expect(group_genre).to be_invalid
    end
  end
end
