module LetMeIn
  module Authentication

    def self.included(base)
      base.send :helper_method, :current_user, :logged_in? if base.respond_to? :helper_method
    end

    def login(user:, password:, permanent: false)
      set_cookie(user_id: user.id, permanent: permanent) if user && user.authenticate(password)
      # zwróci nil jak się nie powiedzie
    end

    def logout
      session[:user_id] = nil
      cookies[:user_id] = nil
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id] || cookies.signed[:user_id])
    end

    def logged_in?
      !!current_user
    end

    private
    def set_cookie(user_id:, permanent:)
      if permanent
        cookies.permanent.signed[:user_id] = user_id
      else
        session[:user_id] = user_id
      end
    end
  end
end
