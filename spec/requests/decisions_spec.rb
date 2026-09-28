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

    it "メンバーは店舗を決定できない" do
      member_user = create(:user)

      member = create(
        :group_member,
        group: group,
        user: member_user,
        role: "member",
        nickname: "メンバー"
      )

      post session_path, params: {
        email: member_user.email,
        password: "password"
      }

      expect {
        patch update_group_decision_path(
          group,
          group_member_id: member.id,
          restaurant_id: restaurant.id
        )
      }.not_to change { group.reload.decided_restaurant_id }

      expect(response).to redirect_to(group_path(group))
    end

    it "別グループの店舗IDを指定しても店舗を決定できない" do
      other_user = create(:user)
      other_group = create(:group, creator: other_user)
      other_group_member = create(
        :group_member,
        group: other_group,
        user: other_user,
        role: "organizer"
      )
      other_group_genre = create(:group_genre, group: other_group)
      other_group_area = create(:group_area, group: other_group)

      other_restaurant = Restaurant.create!(
        group: other_group,
        added_by: other_group_member,
        group_genre: other_group_genre,
        group_area: other_group_area,
        name: "別グループの店舗",
        budget: 3000
      )

      patch update_group_decision_path(
        group,
        group_member_id: group_member.id,
        restaurant_id: other_restaurant.id
      )

      expect(response).to have_http_status(:not_found)
      expect(group.reload.decided_restaurant_id).to be_nil
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
