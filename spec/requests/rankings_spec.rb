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
  end
end
