require "rails_helper"

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
          },
          nickname: "テスト幹事"
        }
      }.to change(GroupMember, :count).by(1)

      group = Group.last
      group_member = GroupMember.last

      expect(group_member.group).to eq(group)
      expect(group_member.user).to eq(user)
      expect(group_member.role).to eq("organizer")
      expect(group_member.nickname).to eq("テスト幹事")
    end
  end

  describe "GET /groups" do
    let(:user) { create(:user) }

    it "ログインユーザーのグループ一覧を表示する" do
      post session_path, params: {
        email: user.email,
        password: "password"
      }

      get groups_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /groups/:id" do
    let(:user) { create(:user) }

    it "グループ詳細画面に参加メンバーと共有URLを表示する" do
      post session_path, params: {
        email: user.email,
        password: "password"
      }

      group = create(:group, creator: user)

      create(
        :group_member,
        group: group,
        user: user,
        role: "organizer",
        nickname: "幹事さん"
      )

      create(
        :group_member,
        group: group,
        nickname: "メンバーさん1"
      )

      create(
        :group_member,
        group: group,
        nickname: "メンバーさん2"
      )

      get group_path(group)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("幹事さん")
      expect(response.body).to include("メンバーさん1")
      expect(response.body).to include("メンバーさん2")
      expect(response.body).to include(
        "/groups/join/#{group.invite_token}"
      )
    end
  end
end
