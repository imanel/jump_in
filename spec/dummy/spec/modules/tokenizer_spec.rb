require_relative '../spec_helper'

describe LetMeIn::Tokenizer do

  context ".generate_token" do
    it 'generates token' do
      token = LetMeIn::Tokenizer.generate_token
      expect(token).to_not eq(nil)
    end
  end

  context ".decode_time" do
    it "decodes time correctly" do
      time = Time.now.xmlschema
      token = Base64.encode64 [SecureRandom.hex(12), time].join(LetMeIn::Tokenizer::DELIMITER)
      expect(LetMeIn::Tokenizer.decode_time(token)).to eq(time)
    end
  end
end
