class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    login(user: user, password: params[:session][:password]) if user
    render nothing: true
  end

  def destroy
    logout
    render nothing: true
  end
end
