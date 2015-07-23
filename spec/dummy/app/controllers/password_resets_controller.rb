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
    @token = params[:token]
  end

  def update
    @user = User.where(password_reset_token: params[:reset_token]).first
    if @user && update_password_reset_for(user: @user,
                                          password: params[:password],
                                          password_confirmation: params[:password_confirmation],
                                          reset_token: params[:reset_token])
       redirect_to login_path
    else
      render :edit
    end
  end
end
