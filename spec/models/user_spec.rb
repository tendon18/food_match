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

  describe "バリデーション" do
    it "パスワードが必須である" do
      user = build(:user, password: "")

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "パスワード確認が一致しない場合は無効である" do
      user = build(:user, password_confirmation: "different")

      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to be_present
    end

    it "メールアドレスが必須である" do
      user = build(:user, email: "")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "メールアドレスが重複すると無効である" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("はすでに登録されています")
    end
  end
end
