module JumpIn
  module Authentication
    class ByPassword < Strategy
      def self.detected?(params)
        params.include? :password
      end

      def authenticate_user
        @user.authenticate(@params[:password]) ? true : false
      end
    end
  end
end
