require 'rails_helper'

RSpec.describe "Restaurants", type: :request do
  describe "GET /new" do
    it "returns http success" do
      group = create(:group)
      group_member = create(:group_member, group: group)
      create(:group_genre, group: group)
      create(:group_area, group: group)

      get "/groups/#{group.id}/restaurants/new",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /groups/:group_id/restaurants" do
    let(:user) { create(:user) }

    it "候補店舗を登録する" do
      post session_path, params: {
        email: user.email,
        password: "password"
      }

      group = create(:group, creator: user)

      group_member = create(
        :group_member,
        group: group,
        user: user,
        role: "organizer",
        nickname: "幹事"
      )

      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      expect {
        post "/groups/#{group.id}/restaurants", params: {
          restaurant: {
            name: "イタリアンA店",
            features: "辛い料理なし",
            url: "https://example.com",
            memo: "駅から近い"
          },
          budget: 3000,
          group_genre_id: group_genre.id,
          group_area_id: group_area.id,
          group_member_id: group_member.id
        }
      }.to change(Restaurant, :count).by(1)

      expect(response).to have_http_status(:redirect)

      restaurant = Restaurant.last

      expect(restaurant.group).to eq(group)
      expect(restaurant.added_by).to eq(group_member)
      expect(restaurant.name).to eq("イタリアンA店")
      expect(restaurant.budget).to eq(3000)
      expect(restaurant.group_genre).to eq(group_genre)
      expect(restaurant.group_area).to eq(group_area)
    end
  end

  describe "GET /groups/:group_id/restaurants/:id/edit" do
    it "自分が追加した候補店舗の編集画面を表示できる" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group
      )

      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      restaurant = Restaurant.create!(
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 3000
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/edit",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
    end

    it "他人が追加した候補店舗の編集画面にはアクセスできない" do
      group = create(:group)

      my_group_member = create(
        :group_member,
        group: group
      )

      other_group_member = create(
        :group_member,
        group: group,
        nickname: "他の参加者"
      )

      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      restaurant = Restaurant.create!(
        group: group,
        added_by: other_group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンB店",
        budget: 3000
      )

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/edit",
        params: { group_member_id: my_group_member.id }

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(
        restaurant_path(
          group,
          restaurant,
          group_member_id: my_group_member.id
        )
      )
    end
  end

  describe "PATCH /groups/:group_id/restaurants/:id" do
    it "編集した内容を保存できる" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group
      )

      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      restaurant = Restaurant.create!(
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 3000,
        features: "駅から近い",
        url: "https://example.com",
        memo: "元のメモ"
      )

      patch "/groups/#{group.id}/restaurants/#{restaurant.id}",
        params: {
          name: "イタリアンB店",
          budget: 4000,
          group_genre_id: group_genre.id,
          group_area_id: group_area.id,
          features: "個室あり",
          url: "https://example.jp",
          memo: "編集後のメモ",
          group_member_id: group_member.id
        }

      expect(response).to have_http_status(:redirect)

      restaurant.reload

      expect(restaurant.name).to eq("イタリアンB店")
      expect(restaurant.budget).to eq(4000)
      expect(restaurant.features).to eq("個室あり")
      expect(restaurant.url).to eq("https://example.jp")
      expect(restaurant.memo).to eq("編集後のメモ")
    end
  end

  describe "GET /groups/:group_id/restaurants/:id" do
    it "編集後の内容が候補店舗詳細画面に反映される" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group
      )

      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      restaurant = Restaurant.create!(
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 3000,
        features: "駅から近い",
        url: "https://example.com",
        memo: "元のメモ"
      )

      patch "/groups/#{group.id}/restaurants/#{restaurant.id}",
        params: {
          name: "イタリアンB店",
          budget: 4000,
          group_genre_id: group_genre.id,
          group_area_id: group_area.id,
          features: "個室あり",
          url: "https://example.jp",
          memo: "編集後のメモ",
          group_member_id: group_member.id
        }

      get "/groups/#{group.id}/restaurants/#{restaurant.id}",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("イタリアンB店")
      expect(response.body).to include("4000")
      expect(response.body).to include("個室あり")
      expect(response.body).to include("https://example.jp")
      expect(response.body).to include("編集後のメモ")
    end
  end

  describe "DELETE /groups/:group_id/restaurants/:id" do
    it "自分が追加した候補店舗を削除できる" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group
      )

      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      restaurant = Restaurant.create!(
        group: group,
        added_by: group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンA店",
        budget: 3000
      )

      expect {
        delete "/groups/#{group.id}/restaurants/#{restaurant.id}",
          params: { group_member_id: group_member.id }
      }.to change(Restaurant, :count).by(-1)

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(
        group_restaurants_index_path(
          group,
          group_member_id: group_member.id
        )
      )
    end

    it "他人が追加した候補店舗は削除できない" do
      group = create(:group)

      my_group_member = create(
        :group_member,
        group: group
      )

      other_group_member = create(
        :group_member,
        group: group,
        nickname: "他の参加者"
      )

      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)

      restaurant = Restaurant.create!(
        group: group,
        added_by: other_group_member,
        group_genre: group_genre,
        group_area: group_area,
        name: "イタリアンB店",
        budget: 3000
      )

      expect {
        delete "/groups/#{group.id}/restaurants/#{restaurant.id}",
          params: { group_member_id: my_group_member.id }
      }.not_to change(Restaurant, :count)

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(
        restaurant_path(
          group,
          restaurant,
          group_member_id: my_group_member.id
        )
      )
    end
  end

  describe "GET /groups/:group_id/restaurants/:id" do
    it "削除済みの候補店舗にアクセスすると一覧画面へ戻る" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group
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

      restaurant_id = restaurant.id
      restaurant.destroy!

      get "/groups/#{group.id}/restaurants/#{restaurant_id}",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(
        group_restaurants_index_path(
          group,
          group_member_id: group_member.id
        )
      )
    end
  end
end
