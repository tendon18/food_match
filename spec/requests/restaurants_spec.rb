require 'rails_helper'

RSpec.describe "Restaurants", type: :request do
  describe "GET /new" do
    it "returns http success" do
      group = create(:group)
      create(:group_genre, group: group)
      create(:group_area, group: group)

      get "/groups/#{group.id}/restaurants/new"

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
          group_area_id: group_area.id
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
end
