module LetMeIn
  class Tokenizer
    require 'base64'

    def self.generate_token
      Base64.encode64("#{SecureRandom.hex(10)}.#{Time.now}")
    end

    def self.decode_time(token)
      token_time = Base64.decode64(token).slice(-25,25)
      Time.parse(token_time)
    end

  end
end

