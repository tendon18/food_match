require 'rails_helper'

RSpec.describe "Rankings", type: :request do
  describe "GET /groups/:group_id/ranking" do
    it "returns http success" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "organizer"
      )

      get "/groups/#{group.id}/ranking",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
    end

    it "幹事には合計スコアを表示する" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "organizer"
      )

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
        name: "イタリアンA店",
        budget: 3000
      )

      get "/groups/#{group.id}/ranking",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("合計スコア：")
      expect(response.body).to include("2点")
    end

    it "メンバーには合計スコアを表示しない" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "member"
      )

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
        name: "イタリアンA店",
        budget: 3000
      )

      get "/groups/#{group.id}/ranking",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include(restaurant.name)
      expect(response.body).not_to include("合計スコア：")
    end
  end

  describe "GET /groups/:group_id/restaurants/:restaurant_id/score" do
    it "スコア詳細画面を表示する" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "organizer"
      )

      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 3000
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
    end

    it "スコア詳細画面に合計スコアを表示する" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "organizer"
      )

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
        name: "イタリアンA店",
        budget: 3000
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member.id }

        expect(response).to have_http_status(:success)
        expect(response.body).to include("合計スコア")
        expect(response.body).to include("2点")
    end

    it "スコア詳細画面に上位になった理由を表示する" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "organizer"
      )

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
        name: "イタリアンA店",
        budget: 3000
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("このお店が上位になった理由")
    end

    it "スコア詳細画面に予算の一致理由を表示する" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "organizer"
      )

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
        name: "イタリアンA店",
        budget: 3000
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("予算内")
    end

    it "スコア詳細画面にジャンルの一致理由を表示する" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "organizer"
      )

      group_genre = create(
        :group_genre,
        group: group,
        genre: "イタリアン"
      )

      group_area = create(:group_area, group: group)

      participant_condition = ParticipantCondition.create!(
        group_member: group_member,
        budget: 3000
      )

      ParticipantConditionGenre.create!(
        participant_condition: participant_condition,
        group_genre: group_genre
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 3000
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("ジャンルが一致")
    end

    it "スコア詳細画面にエリアの一致理由を表示する" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "organizer"
      )

      group_genre = create(:group_genre, group: group)

      group_area = create(
        :group_area,
        group: group,
        area: "渋谷"
      )

      participant_condition = ParticipantCondition.create!(
        group_member: group_member,
        budget: 3000
      )

      ParticipantConditionArea.create!(
        participant_condition: participant_condition,
        group_area: group_area
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 3000
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("エリアが一致")
    end
    
    it "スコア詳細画面にNG条件に該当しない理由を表示する" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "organizer"
      )

      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      participant_condition = ParticipantCondition.create!(
        group_member: group_member,
        budget: 3000
      )

      group_avoid_condition = GroupAvoidCondition.create!(
        group: group,
        condition: "辛い料理"
      )

      ParticipantConditionAvoid.create!(
        participant_condition: participant_condition,
        group_avoid_condition: group_avoid_condition
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 3000
      )

      RestaurantAvoidCondition.create!(
        restaurant: restaurant,
        group_avoid_condition: group_avoid_condition,
        status: "not_applicable"
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("NG条件に該当しない")
    end
  end
end
