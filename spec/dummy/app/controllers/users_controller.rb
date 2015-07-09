class UsersController < ApplicationController
  before_filter :authenticate, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
  end

  def show
    @user = User.find(params[:id])
    render nothing: true
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def authenticate
    render nothing: true, status: 401 unless logged_in?
  end

end
