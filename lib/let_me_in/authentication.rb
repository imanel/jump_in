module LetMeIn
  module Authentication

    def self.included(base)
      base.send :helper_method, :current_user, :logged_in? if base.respond_to? :helper_method
    end

    def login(user:, password:, permanent: false)
      return false unless user.authenticate(password)
      if permanent
        cookies.permanent.signed[:user_id] = user.id
      else
        session[:user_id] = user.id
      end
      true
    end

    def logout
      if session[:user_id]
        session.delete :user_id
      elsif cookies[:user_id]
        cookies.delete :user_id
      end
      true
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id] || cookies.signed[:user_id])
    end

    def logged_in?
      !!current_user
    end

  end
end
