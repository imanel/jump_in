require 'let_me_in/authentication/strategy'
require 'let_me_in/authentication/by_password'

module LetMeIn
  module Authentication

    STRATEGIES = [ByPassword]

    def self.included(base)
      base.send :helper_method, :current_user, :logged_in? if base.respond_to? :helper_method
    end

# LOGGING IN
    def let_me_in(user:, permanent: false, expires: nil, **params)
      return false if logged_in?
      if authenticate_by_strategy(user: user, params: params)
        login(user: user, permanent: permanent, expires: expires)
      else
        return false
      end
    end

    def authenticate_by_strategy(user:, params:)
      if strategy = detected_strategy(user: user, params: params)
        strategy.authenticate_user
      else
        false
      end
    end

    def login(user:, permanent: false, expires: nil)
      if permanent
        set_cookies(user: user, expires: expires)
      else
        set_session(user: user)
      end
      true
    end

    def set_cookies(user:, expires:)
      expires = (expires || 20.years).from_now
      cookies.signed[:let_me_in_class] = { value: user.class.to_s, expires: expires }
      cookies.signed[:let_me_in_id]    = { value: user.id, expires: expires }
    end

    def set_session(user:)
      session[:let_me_in_class] = user.class.to_s
      session[:let_me_in_id]    = user.id
    end

# LOGGING OUT
    def let_me_out
      if session[:let_me_in_id] && session[:let_me_in_class]
        delete_session
      elsif cookies[:let_me_in_id] && cookies[:let_me_in_class]
        delete_cookies
      end
      true
    end

    def delete_cookies
      cookies.delete :let_me_in_class
      cookies.delete :let_me_in_id
    end

    def delete_session
      session.delete :let_me_in_class
      session.delete :let_me_in_id
    end

# HELPER METHODS
    def current_user
      return nil unless session_or_cookies_set?
      klass = (session[:let_me_in_class] || cookies.signed[:let_me_in_class]).constantize
      id    = (session[:let_me_in_id] || cookies.signed[:let_me_in_id])
      @current_user ||= klass.find_by_id(id)
    end

    def logged_in?
      !!current_user
    end

    private
    def session_or_cookies_set?
      (session[:let_me_in_id] && session[:let_me_in_class]) ||
      (cookies.signed[:let_me_in_id] && cookies.signed[:let_me_in_class])
    end

    def detected_strategy(user: user, params: params)
      if strategy = STRATEGIES.detect { |strategy| strategy.detected?(params) }
        strategy.new(user: user, params: params)
      else
        false
      end
    end
  end
end
