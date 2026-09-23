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

  describe "#genre_score" do
    it "店舗のジャンルが参加者の希望ジャンルと一致したら2点加算する" do
      group = create(:group)
      group_member = create(:group_member, group: group)

      group_genre = create(
        :group_genre,
        group: group,
        genre: "焼肉"
      )

      group_area = create(:group_area, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 3000
      )

      participant_condition = ParticipantCondition.create!(
        group_member: group_member
      )

      ParticipantConditionGenre.create!(
        participant_condition: participant_condition,
        group_genre: group_genre
      )

      expect(restaurant.genre_score([group_member])).to eq(2)
    end

    it "店舗のジャンルが参加者の希望ジャンルと一致しなければ0点" do
      group = create(:group)
      group_member = create(:group_member, group: group)

      restaurant_genre = create(
        :group_genre,
        group: group,
        genre: "焼肉"
      )

      preferred_genre = create(
        :group_genre,
        group: group,
        genre: "和食"
      )

      group_area = create(:group_area, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: restaurant_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 3000
      )

      participant_condition = ParticipantCondition.create!(
        group_member: group_member
      )

      ParticipantConditionGenre.create!(
        participant_condition: participant_condition,
        group_genre: preferred_genre
      )

      expect(restaurant.genre_score([group_member])).to eq(0)
    end

    it "希望ジャンルを複数選択していても一致した場合は2点だけ加算する" do
      group = create(:group)
      group_member = create(:group_member, group: group)

      restaurant_genre = create(
        :group_genre,
        group: group,
        genre: "焼肉"
      )

      preferred_genre = create(
        :group_genre,
        group: group,
        genre: "和食"
      )

      group_area = create(:group_area, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: restaurant_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 3000
      )

      participant_condition = ParticipantCondition.create!(
        group_member: group_member
      )

      ParticipantConditionGenre.create!(
        participant_condition: participant_condition,
        group_genre: restaurant_genre
      )

      ParticipantConditionGenre.create!(
        participant_condition: participant_condition,
        group_genre: preferred_genre
      )

      expect(restaurant.genre_score([group_member])).to eq(2)
    end

    it "参加者が希望ジャンルを選択していなければ0点" do
      group = create(:group)
      group_member = create(:group_member, group: group)

      group_genre = create(
        :group_genre,
        group: group,
        genre: "焼肉"
      )

      group_area = create(:group_area, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 3000
      )

      ParticipantCondition.create!(
        group_member: group_member
      )

      expect(restaurant.genre_score([group_member])).to eq(0)
    end

    it "複数の参加者のジャンルスコアを合計する" do
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

      restaurant_genre = create(
        :group_genre,
        group: group,
        genre: "焼肉"
      )

      preferred_genre = create(
        :group_genre,
        group: group,
        genre: "和食"
      )

      group_area = create(:group_area, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member_a,
        group_genre: restaurant_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 3000
      )

      participant_condition_a = ParticipantCondition.create!(
        group_member: group_member_a
      )

      ParticipantConditionGenre.create!(
        participant_condition: participant_condition_a,
        group_genre: restaurant_genre
      )

      participant_condition_b = ParticipantCondition.create!(
        group_member: group_member_b
      )

      ParticipantConditionGenre.create!(
        participant_condition: participant_condition_b,
        group_genre: preferred_genre
      )

      expect(
        restaurant.genre_score([group_member_a, group_member_b])
      ).to eq(2)
    end
  end

  describe "#area_score" do
    it "店舗のエリアが参加者の希望エリアと一致したら2点加算する" do
      group = create(:group)
      group_member = create(:group_member, group: group)

      group_area = create(
        :group_area,
        group: group,
        area: "新宿"
      )

      group_genre = create(:group_genre, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 3000
      )

      participant_condition = ParticipantCondition.create!(
        group_member: group_member
      )

      ParticipantConditionArea.create!(
        participant_condition: participant_condition,
        group_area: group_area
      )

      expect(restaurant.area_score([group_member])).to eq(2)
    end

    it "店舗のエリアが参加者の希望エリアと一致しなければ0点" do
      group = create(:group)
      group_member = create(:group_member, group: group)

      restaurant_area = create(
        :group_area,
        group: group,
        area: "新宿"
      )

      preferred_area = create(
        :group_area,
        group: group,
        area: "渋谷"
      )

      group_genre = create(:group_genre, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: restaurant_area,
        name: "テスト店舗",
        budget: 3000
      )

      participant_condition = ParticipantCondition.create!(
        group_member: group_member
      )

      ParticipantConditionArea.create!(
        participant_condition: participant_condition,
        group_area: preferred_area
      )

      expect(restaurant.area_score([group_member])).to eq(0)
    end

    it "希望エリアを複数選択していても一致した場合は2点だけ加算する" do
      group = create(:group)
      group_member = create(:group_member, group: group)

      restaurant_area = create(
        :group_area,
        group: group,
        area: "新宿"
      )

      preferred_area = create(
        :group_area,
        group: group,
        area: "渋谷"
      )

      group_genre = create(:group_genre, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: restaurant_area,
        name: "テスト店舗",
        budget: 3000
      )

      participant_condition = ParticipantCondition.create!(
        group_member: group_member
      )

      ParticipantConditionArea.create!(
        participant_condition: participant_condition,
        group_area: restaurant_area
      )

      ParticipantConditionArea.create!(
        participant_condition: participant_condition,
        group_area: preferred_area
      )

      expect(restaurant.area_score([group_member])).to eq(2)
    end

    it "参加者が希望エリアを選択していなければ0点" do
      group = create(:group)
      group_member = create(:group_member, group: group)

      group_area = create(
        :group_area,
        group: group,
        area: "新宿"
      )

      group_genre = create(:group_genre, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "テスト店舗",
        budget: 3000
      )

      ParticipantCondition.create!(
        group_member: group_member
      )

      expect(restaurant.area_score([group_member])).to eq(0)
    end

    it "複数の参加者のエリアスコアを合計する" do
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

      restaurant_area = create(
        :group_area,
        group: group,
        area: "新宿"
      )

      preferred_area = create(
        :group_area,
        group: group,
        area: "渋谷"
      )

      group_genre = create(:group_genre, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member_a,
        group_genre: group_genre,
        group_area: restaurant_area,
        name: "テスト店舗",
        budget: 3000
      )

      participant_condition_a = ParticipantCondition.create!(
        group_member: group_member_a
      )

      ParticipantConditionArea.create!(
        participant_condition: participant_condition_a,
        group_area: restaurant_area
      )

      participant_condition_b = ParticipantCondition.create!(
        group_member: group_member_b
      )

      ParticipantConditionArea.create!(
        participant_condition: participant_condition_b,
        group_area: preferred_area
      )

      expect(
        restaurant.area_score([group_member_a, group_member_b])
      ).to eq(2)
    end
  end
end
