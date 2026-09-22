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

  describe "PATCH /groups/:group_id/restaurants/:restaurant_id/avoid_conditions" do
    it "updates the restaurant avoid condition" do
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

      group_avoid_condition = GroupAvoidCondition.create!(
        group: group,
        condition: "辛い料理",
        status: "avoid"
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

      restaurant_avoid_condition = RestaurantAvoidCondition.create!(
        restaurant: restaurant,
        group_avoid_condition: group_avoid_condition,
        status: "not_applicable"
      )

      patch "/groups/#{group.id}/restaurants/#{restaurant.id}/avoid_conditions",
        params: {
          group_member_id: group_member.id,
          conditions: {
            group_avoid_condition.id.to_s => "applicable"
          }
        }

      expect(response).to redirect_to(
        restaurant_path(
          group,
          restaurant,
          group_member_id: group_member.id
        )
      )

      expect(restaurant_avoid_condition.reload.status).to eq("applicable")
    end
  end
end
