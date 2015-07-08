module LetMeIn
  class Tokenizer

    def self.call
      SecureRandom.urlsafe_base64
    end

  end
end

