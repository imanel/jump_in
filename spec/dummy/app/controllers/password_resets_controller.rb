class PasswordResetsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if create_password_reset_for(user: @user, mailer: SystemMailer)
      redirect_to login_path
    else
      render :new
    end
  end

  def edit
    @user = User.where(reset_digest: params[:token]).first
  end

  def update
    @user = User.where(reset_digest: params[:user][:token]).first
    if @user && update_password_reset_for(user: @user,
        password: user_params[:password],
        password_confirmation: user_params[:password_confirmation],
        reset_token: user_params[:token],
        email: user_params[:email])
      login(user: @user, password: user_params[:password])
      render nothing: true
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :token)
  end
end
