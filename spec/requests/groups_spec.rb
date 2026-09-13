require 'rails_helper'

RSpec.describe "Groups", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/groups/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /groups" do
    let(:user) { create(:user) }

    it "ログインユーザーをorganizerとして登録する" do
      post session_path, params: {
        email: user.email,
        password: "password"
      }

      expect {
        post groups_path, params: {
          group: {
            name: "テストグループ"
          }
        }
      }.to change(GroupMember, :count).by(1)

      group = Group.last
      group_member = GroupMember.last

      expect(group_member.group).to eq(group)
      expect(group_member.user).to eq(user)
      expect(group_member.role).to eq("organizer")
    end
  end
end
