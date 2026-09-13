require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "POST /sessions (create)" do
    context "メールアドレスとパスワードが正しい場合" do
      it "ログインに成功しグループ一覧へリダイレクトする" do
        post session_path, params: {
          email: user.email,
          password: "password"
        }

        expect(response).to redirect_to(groups_path)
      end
    end

    context "メールアドレスまたはパスワードが誤っている場合" do
      it "ログインに失敗しnewテンプレートを再表示する" do
        post session_path, params: { email: user.email, password: "wrong_password" }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE /sessions (destroy)" do
    it "ログアウトに成功しroot_pathへリダイレクトする" do
      delete session_path
      expect(response).to redirect_to(root_path)
    end
  end
end
