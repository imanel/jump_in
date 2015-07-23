module LetMeIn
  class Tokenizer
    require 'base64'

    def initialize(token = nil)
      @token = token
    end

    def generate_token
      Base64.encode64("#{SecureRandom.hex(10)}.#{Time.now}")
    end

    def decode_time
      time = Base64.decode64(@token).slice(21,25)
      token_datetime = Time.parse(time)
    end

  end
end

