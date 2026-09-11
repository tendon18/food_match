class SessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to root_path
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
