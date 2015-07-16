module LetMeIn
  module Authentication

    def self.included(base)
      base.send :helper_method, :current_user, :logged_in? if base.respond_to? :helper_method
    end

    def login(user:, password:, permanent: false)
      if user && user.authenticate(password)
        set_cookie(user_id: user.id, permanent: permanent)
        flash[:success] = "Successfully logged in."
        return true
      else
        flash[:error] = "There was a problem loggin in. Please check your email and password."
        return false
      end
    end

    def logout
      session[:user_id] = nil
      cookies[:user_id] = nil
      flash[:success] = "Successfully logged out."
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id] || cookies.signed[:user_id])
    end

    def logged_in?
      !!current_user
    end

    private
    def set_cookie(user_id:, permanent:)
      case
      when permanent == true
        cookies.permanent.signed[:user_id] = user_id
      when permanent == false
        session[:user_id] = user_id
      end
    end
  end
end
