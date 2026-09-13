class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    user&.deliver_reset_password_instructions!

    redirect_to root_path
  end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
  end

  def update
    user = User.load_from_reset_password_token(params[:id])

    unless user
      redirect_to new_password_reset_path, alert: "パスワード再設定用のURLが無効です。"
      return
    end

    user.password = params[:user][:password]
    user.password_confirmation = params[:user][:password_confirmation]

    if user.valid?
      user.change_password!(
        params[:user][:password]
      )

      redirect_to new_session_path, notice: "パスワードを変更しました。"
    else
      redirect_to edit_password_reset_path(params[:id]), alert: "パスワードと確認用パスワードが一致しません。"
    end
  end
end
