module LetMeIn
  module PasswordReset

    def set_password_reset_for(user:)
      reset_token = loop do
        token = LetMeIn::Tokenizer.generate_token
        break token unless user.class.where(password_reset_token: token).exists?
      end
      user.update_attribute(:password_reset_token, reset_token)
    end

    def password_reset_valid?(password_reset_token:, expiration_time: 2.hours)
      LetMeIn::Tokenizer.decode_time(password_reset_token) > Time.now - expiration_time
    end

    def update_password_for(user:, password:, password_confirmation:, password_reset_token:)
      if user.password_reset_token == password_reset_token
        user.update_attributes(password: password, password_confirmation: password_confirmation,
                               password_reset_token: nil)
      else
        return false
      end
    end

  end
end
