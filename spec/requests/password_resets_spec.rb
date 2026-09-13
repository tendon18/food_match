require "rails_helper"

RSpec.describe "PasswordResets", type: :request do
  describe "GET /password_resets/new" do
    it "パスワード再設定申請画面を表示する" do
      get new_password_reset_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /password_resets" do
    it "パスワード再設定メールを送信してroot_pathへリダイレクトする" do
      user = User.create!(
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      )

      post password_resets_path, params: { email: user.email }

      expect(response).to redirect_to(root_path)
      expect(user.reload.reset_password_token).to be_present
    end
  end

  describe "GET /password_resets/:id/edit" do
    it "パスワード再設定画面を表示する" do
      user = User.create!(
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      )

      user.generate_reset_password_token!

      get edit_password_reset_path(user.reset_password_token)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /password_resets/:id" do
    it "正しいトークンならパスワードを変更してログイン画面へリダイレクトする" do
      user = User.create!(
        email: "reset@example.com",
        password: "old_password",
        password_confirmation: "old_password"
      )

      user.deliver_reset_password_instructions!
      token = user.reset_password_token

      patch password_reset_path(token), params: {
        user: {
          password: "new_password",
          password_confirmation: "new_password"
        }
      }

      expect(response).to redirect_to(new_session_path)
      expect(user.reload.valid_password?("new_password")).to be true
    end

    it "パスワードと確認用パスワードが一致しなければ変更しない" do
      user = User.create!(
        email: "reset-mismatch@example.com",
        password: "old_password",
        password_confirmation: "old_password"
      )

      user.deliver_reset_password_instructions!
      token = user.reset_password_token

      patch password_reset_path(token), params: {
        user: {
          password: "new_password",
          password_confirmation: "different_password"
        }
      }

      expect(response).to redirect_to(edit_password_reset_path(token))
      expect(user.reload.valid_password?("old_password")).to be true
    end
  end
end
