require "rails_helper"

RSpec.describe "ParticipantConditions", type: :request do
  describe "GET /groups/:group_id/participant_conditions/:group_member_id" do
    let(:user) { create(:user) }
    let(:group) { create(:group, creator: user) }
    let(:group_member) { create(:group_member, group: group) }

    it "returns http success" do
      get new_participant_condition_path(group, group_member)

      expect(response).to have_http_status(:success)
    end
  end
end
