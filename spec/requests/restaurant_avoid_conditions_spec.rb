require 'rails_helper'

RSpec.describe "RestaurantAvoidConditions", type: :request do
  describe "GET /groups/:group_id/restaurants/:restaurant_id/avoid_conditions/new" do
    it "returns http success" do
      group = create(:group)

      group_member = create(
        :group_member,
        group: group
      )

      group_genre = create(
        :group_genre,
        group: group
      )

      group_area = create(
        :group_area,
        group: group
      )

      GroupAvoidCondition.create!(
        group: group,
        condition: "辛い料理",
        status: "該当する"
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

      get "/groups/#{group.id}/restaurants/#{restaurant.id}/avoid_conditions/new",
        params: { group_member_id: group_member.id }

      expect(response).to have_http_status(:success)
    end
  end
end
