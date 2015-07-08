class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    login(user: user, password: params[:session][:password]) if user
  end

  def destroy
    logout
  end
end