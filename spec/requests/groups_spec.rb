require "rails_helper"

RSpec.describe "Groups", type: :request do
  describe "GET /new" do
    let(:user) { create(:user) }

    it "ログインユーザーはグループ作成画面を表示できる" do
      post session_path, params: {
        email: user.email,
        password: "password"
      }

      get "/groups/new"

      expect(response).to have_http_status(:success)
    end

    it "未ログインユーザーはログイン画面へリダイレクトされる" do
      get "/groups/new"

      expect(response).to redirect_to(root_path)
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
      expect(response).to redirect_to(group_conditions_area_path(group))
    end

    it "グループ名が空の場合はグループを作成せず作成画面を再表示する" do
      post session_path, params: {
        email: user.email,
        password: "password"
      }

      expect {
        post groups_path, params: {
          group: {
            name: ""
          },
          nickname: "テスト幹事"
        }
      }.not_to change(Group, :count)

      expect(response).to have_http_status(:unprocessable_entity)
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

    it "未ログインで参加者セッションがない場合はトップページへリダイレクトされる" do
      group = create(:group)

      create(
        :group_member,
        group: group,
        role: "organizer",
        nickname: "幹事さん"
      )

      get group_path(group)

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /groups/join/:invite_token" do
    let(:group) { create(:group) }

    it "招待URLから参加画面を表示できる" do
      get "/groups/join/#{group.invite_token}"

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /groups/join/:invite_token" do
    let(:group) { create(:group) }

    it "参加者を登録して参加条件入力画面へ進む" do
      expect {
        post "/groups/join/#{group.invite_token}", params: {
          nickname: "参加者さん"
        }
      }.to change(GroupMember, :count).by(1)

      group_member = GroupMember.last

      expect(group_member.group).to eq(group)
      expect(group_member.nickname).to eq("参加者さん")
      expect(response).to redirect_to(
        new_participant_condition_path(group, group_member)
      )
    end

    it "同じニックネームがすでに参加している場合は参加画面を再表示する" do
      create(
        :group_member,
        group: group,
        nickname: "参加者さん"
      )

      expect {
        post "/groups/join/#{group.invite_token}", params: {
          nickname: "参加者さん"
        }
      }.not_to change(GroupMember, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("※このニックネームはすでに参加しています")
    end
  end
end
