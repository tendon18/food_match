require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe "#budget_score" do
    it "予算以内の場合は2点加点する" do
      group = create(:group)
      group_member = create(:group_member, group: group)
      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      ParticipantCondition.create!(
        group_member: group_member,
        budget: 3000
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 3000
      )

      expect(restaurant.budget_score([group_member])).to eq(2)
    end

    it "予算を500円超過した場合は1点減点する" do
      group = create(:group)
      group_member = create(:group_member, group: group)
      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      ParticipantCondition.create!(
        group_member: group_member,
        budget: 3000
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 3500
      )

      expect(restaurant.budget_score([group_member])).to eq(-1)
    end

    it "予算を1000円超過した場合は2点減点する" do
      group = create(:group)
      group_member = create(:group_member, group: group)
      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      ParticipantCondition.create!(
        group_member: group_member,
        budget: 3000
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 4000
      )

      expect(restaurant.budget_score([group_member])).to eq(-2)
    end

    it "複数の参加者の予算スコアを合計する" do
      group = create(:group)

      group_member_a = create(
        :group_member,
        group: group,
        nickname: "テストユーザーA"
      )

      group_member_b = create(
        :group_member,
        group: group,
        nickname: "テストユーザーB"
      )

      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      ParticipantCondition.create!(
        group_member: group_member_a,
        budget: 3000
      )

      ParticipantCondition.create!(
        group_member: group_member_b,
        budget: 2500
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member_a,
        group_genre: group_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 3000
      )

      expect(
        restaurant.budget_score([group_member_a, group_member_b])
      ).to eq(1)
    end
  end
end
