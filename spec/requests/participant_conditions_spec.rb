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

  describe "POST /groups/:group_id/participant_conditions/:group_member_id" do
    let(:user) { create(:user) }
    let(:group) { create(:group, creator: user) }
    let(:group_member) { create(:group_member, group: group) }

    it "参加者条件を登録して完了画面へリダイレクトする" do
      group_genre = create(:group_genre, group: group)
      group_area = create(:group_area, group: group)
      group_avoid_condition = group.group_avoid_conditions.create!(
        condition: "喫煙"
      )

      post create_participant_condition_path(group, group_member),
        params: {
          budget: 3000,
          genre_ids: [group_genre.id],
          area_ids: [group_area.id],
          avoid_condition_ids: [group_avoid_condition.id]
        }

      expect(response).to redirect_to(
        participant_condition_complete_path(group, group_member)
      )

      participant_condition = group_member.reload.participant_condition

      expect(participant_condition.budget).to eq(3000)
      expect(
        participant_condition.group_genres
      ).to include(group_genre)
      expect(
        participant_condition.group_areas
      ).to include(group_area)
      expect(
        participant_condition.group_avoid_conditions
      ).to include(group_avoid_condition)
    end
  end
end
