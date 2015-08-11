module LetMeIn
  module Authentication

    class Strategy
      def initialize(user:, hash:)
        @user = user
        @hash = hash
      end

      def authenticate_user
        true
      end
    end

  end
end
