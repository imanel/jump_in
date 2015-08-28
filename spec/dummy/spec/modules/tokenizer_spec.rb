require_relative '../spec_helper'

describe JumpIn::Tokenizer do

  context ".generate_token" do
    it 'generates token' do
      token = JumpIn::Tokenizer.generate_token
      expect(token).to_not eq(nil)
    end
  end

  context ".decode_time" do
    it "decodes time correctly" do
      time = Time.now.xmlschema
      token = Base64.encode64 [SecureRandom.hex(12), time].join(JumpIn::Tokenizer::DELIMITER)
      expect(JumpIn::Tokenizer.decode_time(token)).to eq(time)
    end
  end
end
