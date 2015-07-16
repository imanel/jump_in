class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if login(user: user, password: params[:session][:password], permanent: true)
      redirect_to user_path(user)
    else
      render :new
    end
  end

  def destroy
    logout
    redirect_to login_path
  end
end
