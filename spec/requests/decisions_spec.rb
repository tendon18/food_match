require 'rails_helper'

RSpec.describe "Decisions", type: :request do
  let(:user) { create(:user) }
  let(:group) { create(:group, creator: user) }
  let(:group_member) { create(:group_member, group: group, user: user, role: "organizer") }
  let(:group_genre) { create(:group_genre, group: group) }
  let(:group_area) { create(:group_area, group: group) }

  let(:restaurant) do
    Restaurant.create!(
      group: group,
      added_by: group_member,
      group_genre: group_genre,
      group_area: group_area,
      name: "テスト店舗",
      budget: 3000
    )
  end

  before do
    post session_path, params: {
      email: user.email,
      password: "password"
    }
  end

  describe "GET /groups/:group_id/decision" do
    it "returns http success" do
      get group_decision_path(
        group,
        group_member_id: group_member.id,
        restaurant_id: restaurant.id
      )

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /groups/:group_id/decision" do
    it "店舗を決定して完了画面へリダイレクトする" do
      patch update_group_decision_path(
        group,
        group_member_id: group_member.id,
        restaurant_id: restaurant.id
      )

      expect(response).to redirect_to(
        group_decision_complete_path(
          group,
          group_member_id: group_member.id
        )
      )

      expect(group.reload.decided_restaurant_id).to eq(restaurant.id)
    end
  end

  describe "GET /groups/:group_id/decision/complete" do
    it "決定した店舗を表示する" do
      group.update!(decided_restaurant_id: restaurant.id)

      get group_decision_complete_path(
        group,
        group_member_id: group_member.id
      )

      expect(response).to have_http_status(:success)
    end
  end
end
