class PasswordResetsController < ApplicationController
  before_filter :check_reset_expiration, only: [:update, :edit]

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    create_password_reset_for(user: @user, mailer: UserMailer)
  end

  def edit
  end

  def update
    update_password_reset_for(user: @user, password: user_params[:password],
      password_confirmation: user_params[:password_confirmation],
      password_reset_token: user_params[:password_reset_token], email: user_params[:email])
    login(user: @user, password: user_params[:password]) if user
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :email, :password_reset_token)
  end

  def check_reset_expiration
    password_reset_expired?(user)
  end
end
