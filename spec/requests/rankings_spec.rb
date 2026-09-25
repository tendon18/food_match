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

    it "幹事にはスコア詳細へのリンクを表示する" do
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

      get "/groups/#{group.id}/ranking",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("スコア詳細を見る →")
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

    it "スコア詳細画面に予算オーバーの理由を表示する" do
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
        budget: 3500
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("テストユーザー")
      expect(response.body).to include("500円")
      expect(response.body).to include("予算を500円超過")
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

    it "スコア詳細画面にメンバーごとの一致度を表示する" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group,
        role: "organizer",
        nickname: "Aさん"
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
      expect(response.body).to include("メンバーごとの一致度")
      expect(response.body).to include("Aさん")
    end

    it "スコア詳細画面にランキングに戻るリンクを表示する" do
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
      expect(response.body).to include("ランキングに戻る")
    end

    it "スコア詳細画面にグループ一覧へのリンクを表示する" do
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
      expect(response.body).to include("グループ一覧")
    end

    it "スコア詳細画面に店舗情報を表示する" do
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

      group_area = create(
        :group_area,
        group: group,
        area: "渋谷"
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 2500
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("イタリアンA店")
      expect(response.body).to include("イタリアン")
      expect(response.body).to include("2500円")
      expect(response.body).to include("渋谷")
    end

    it "スコア詳細画面に予算以内の人数を表示する" do
      group = create(:group)

      group_member1 = create(
        :group_member,
        group: group,
        role: "organizer",
        nickname: "Aさん"
      )

      group_member2 = create(
        :group_member,
        group: group,
        nickname: "Bさん"
      )

      group_member3 = create(
        :group_member,
        group: group,
        nickname: "Cさん"
      )

      group_member4 = create(
        :group_member,
        group: group,
        nickname: "Dさん"
      )

      ParticipantCondition.create!(
        group_member: group_member1,
        budget: 3000
      )

      ParticipantCondition.create!(
        group_member: group_member2,
        budget: 2500
      )

      ParticipantCondition.create!(
        group_member: group_member3,
        budget: 3000
      )

      ParticipantCondition.create!(
        group_member: group_member4,
        budget: 2000
      )

      group_genre = create(
        :group_genre,
        group: group,
        genre: "イタリアン"
      )

      group_area = create(
        :group_area,
        group: group,
        area: "渋谷"
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member1,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 2500
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member1.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("4人中3人が予算以内")
    end

    it "スコア詳細画面に希望ジャンルと一致した人数を表示する" do
      group = create(:group)

      group_member1 = create(
        :group_member,
        group: group,
        role: "organizer",
        nickname: "Aさん"
      )

      group_member2 = create(
        :group_member,
        group: group,
        nickname: "Bさん"
      )

      group_member3 = create(
        :group_member,
        group: group,
        nickname: "Cさん"
      )

      group_genre = create(
        :group_genre,
        group: group,
        genre: "イタリアン"
      )

      other_genre = create(
        :group_genre,
        group: group,
        genre: "和食"
      )

      group_area = create(
        :group_area,
        group: group,
        area: "渋谷"
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member1,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 2500
      )

      participant_condition1 = ParticipantCondition.create!(
        group_member: group_member1,
        budget: 3000
      )

      participant_condition1.group_genres << group_genre

      participant_condition2 = ParticipantCondition.create!(
        group_member: group_member2,
        budget: 3000
      )

      participant_condition2.group_genres << group_genre

      participant_condition3 = ParticipantCondition.create!(
        group_member: group_member3,
        budget: 3000
      )

      participant_condition3.group_genres << other_genre

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member1.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("2人が希望ジャンルと一致")
    end

    it "スコア詳細画面に希望エリアと一致した人数を表示する" do
      group = create(:group)

      group_member1 = create(
        :group_member,
        group: group,
        role: "organizer",
        nickname: "Aさん"
      )

      group_member2 = create(
        :group_member,
        group: group,
        nickname: "Bさん"
      )

      group_member3 = create(
        :group_member,
        group: group,
        nickname: "Cさん"
      )

      group_genre = create(
        :group_genre,
        group: group,
        genre: "イタリアン"
      )

      group_area = create(
        :group_area,
        group: group,
        area: "渋谷"
      )

      other_area = create(
        :group_area,
        group: group,
        area: "新宿"
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member1,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 2500
      )

      participant_condition1 = ParticipantCondition.create!(
        group_member: group_member1,
        budget: 3000
      )

      participant_condition1.group_areas << group_area

      participant_condition2 = ParticipantCondition.create!(
        group_member: group_member2,
        budget: 3000
      )

      participant_condition2.group_areas << group_area

      participant_condition3 = ParticipantCondition.create!(
        group_member: group_member3,
        budget: 3000
      )

      participant_condition3.group_areas << other_area

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member1.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("2人が希望エリアと一致")
    end

    it "スコア詳細画面に予算を超過しているメンバーを表示する" do
      group = create(:group)

      group_member1 = create(
        :group_member,
        group: group,
        role: "organizer",
        nickname: "Aさん"
      )

      group_member2 = create(
        :group_member,
        group: group,
        nickname: "Bさん"
      )

      group_member3 = create(
        :group_member,
        group: group,
        nickname: "Cさん"
      )

      group_member4 = create(
        :group_member,
        group: group,
        nickname: "Dさん"
      )

      ParticipantCondition.create!(
        group_member: group_member1,
        budget: 3000
      )

      ParticipantCondition.create!(
        group_member: group_member2,
        budget: 2500
      )

      ParticipantCondition.create!(
        group_member: group_member3,
        budget: 3000
      )

      ParticipantCondition.create!(
      group_member: group_member4,
        budget: 2000
      )

      group_genre = create(
        :group_genre,
        group: group,
        genre: "イタリアン"
      )

      group_area = create(
        :group_area,
        group: group,
        area: "渋谷"
      )

      restaurant = create(
        :restaurant,
        group: group,
        added_by: group_member1,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 2500
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/score",
        params: { group_member_id: group_member1.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Dさん")
      expect(response.body).to include("500円")
      expect(response.body).to include("予算")
    end
  end
end
