require "rails_helper"

RSpec.describe "GroupConditions", type: :request do
  describe "GET /groups/:group_id/conditions/area" do
    let(:user) { create(:user) }
    let(:group) { create(:group, creator: user) }

    it "returns http success for organizer" do
      post session_path, params: {
        email: user.email,
        password: "password"
      }

      get group_conditions_area_path(group)

      expect(response).to have_http_status(:success)
    end

    context "ログインしていない場合" do
      it "グループ設定画面へアクセスできない" do
        get group_conditions_area_path(group)

        expect(response).to redirect_to(group_path(group))
      end
    end
  end
end
