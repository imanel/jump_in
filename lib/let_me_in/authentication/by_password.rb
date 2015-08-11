module LetMeIn
  module Authentication
    class ByPassword < Strategy

      def self.detected?(hash)
        hash.include? :password
      end

      def authenticate_user
        if @user.authenticate(@hash[:password])
          return true
        else
          return false
        end
      end

    end
  end
end
