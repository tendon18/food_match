require "rails_helper"

RSpec.describe "GroupConditions", type: :request do
  describe "GET /groups/:group_id/conditions/area" do
    let(:group) { create(:group) }

    it "returns http success" do
      get group_conditions_area_path(group)

      expect(response).to have_http_status(:success)
    end
  end
end
