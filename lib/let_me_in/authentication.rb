module LetMeIn
  module Authentication

    def self.included(base)
      base.send :helper_method, :current_user, :logged_in? if base.respond_to? :helper_method
    end

# LOGGING IN
    def fullstack_login(user:, password:, permanent: false)
      return false if logged_in? || !authenticate_user(user: user, password: password)
      login(user: user, permanent: permanent)
    end

    def login(user:, permanent: false)
      if permanent
        cookies.permanent.signed[:user_id] = user.id
      else
        session[:user_id] = user.id
      end
      true
    end

    def authenticate_user(user:, password:)
      return false unless user.authenticate(password)
    end

# LOGGING OUT
    def logout
      if session[:user_id]
        session.delete :user_id
      elsif cookies[:user_id]
        cookies.delete :user_id
      end
      true
    end

# HELPER METHODS
    def current_user
      @current_user ||= User.find_by_id(session[:user_id] || cookies.signed[:user_id])
    end

    def logged_in?
      !!current_user
    end

  end
end
