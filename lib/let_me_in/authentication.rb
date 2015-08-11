require 'let_me_in/authentication/strategy'
require 'let_me_in/authentication/by_password'

module LetMeIn
  module Authentication

    STRATEGIES = [ByPassword]

    def self.included(base)
      base.send :helper_method, :current_user, :logged_in? if base.respond_to? :helper_method
    end

# LOGGING IN
    def let_me_in(user:, permanent: false, expires: nil, **hash)
      return false if logged_in?
      strategy = detect_strategy(hash)
      if strategy.new(user: user, hash: hash).authenticate_user
        login(user: user, permanent: permanent, expires: expires)
      else
        return false
      end
    end

    def login(user:, permanent: false, expires: nil)
      if permanent
        expires = Time.now + expires if expires
        cookies.permanent.signed[:let_me_in_class] = { :value => user.class.to_s, :expires => expires }
        cookies.permanent.signed[:let_me_in_id]    = { :value => user.id, :expires => expires }
      else
        session[:let_me_in_class] = user.class.to_s
        session[:let_me_in_id]    = user.id
      end
      true
    end

# LOGGING OUT
    def let_me_out
      if session[:let_me_in_id] && session[:let_me_in_class]
        session.delete :let_me_in_class
        session.delete :let_me_in_id
      elsif cookies[:let_me_in_id] && cookies[:let_me_in_class]
        cookies.delete :let_me_in_class
        cookies.delete :let_me_in_id
      end
      true
    end

# HELPER METHODS
    def current_user
      return nil unless (session[:let_me_in_id] && session[:let_me_in_class]) ||
                        (cookies.signed[:let_me_in_id] && cookies.signed[:let_me_in_class])
      klass = (session[:let_me_in_class] || cookies.signed[:let_me_in_class]).constantize
      id    = (session[:let_me_in_id] || cookies.signed[:let_me_in_id])
      @current_user ||= klass.find_by_id(id)
    end

    def logged_in?
      !!current_user
    end

    private

    def detect_strategy(hash)
      STRATEGIES.detect { |strategy| strategy.detected?(hash) }
    end

  end
end
