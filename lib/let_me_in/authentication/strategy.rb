module LetMeIn
  module Authentication

    class Strategy
      def initialize(user:, params:)
        @user = user
        @params = params
      end

      def authenticate_user
        true
      end
    end

  end
end
