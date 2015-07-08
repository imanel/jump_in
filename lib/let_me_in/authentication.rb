module LetMeIn
  module Authentication

    def self.included(base)
      base.send :helper_method, :current_user, :logged_in? if base.respond_to? :helper_method
    end

    def login(user:, password:)
    end

    def logout
    end

    def current_user
    end

    def logged_in?
    end
  end
end
