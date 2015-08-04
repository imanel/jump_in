require_relative '../spec_helper'
include ActiveSupport::Testing::TimeHelpers

class PasswordResetController < ActionController::Base
  include LetMeIn::PasswordReset
end

describe PasswordResetController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  context "#set_password_reset_for" do
    it "sets password_reset_token if password_reset_token was nil" do
      expect(user.password_reset_token).to eq(nil)
      subject.set_password_reset_for(user: user)
      expect(user.password_reset_token).to_not be_nil
    end

    it "updates password_reset_token if password_reset_token was not nil" do
      user.update_attribute(:password_reset_token, LetMeIn::Tokenizer.generate_token)
      token_before_method_call = user.password_reset_token
      subject.set_password_reset_for(user: user)
      expect(user.password_reset_token).to_not eq(token_before_method_call)
    end
  end

  context "#password_reset_valid?" do
    it "returns true for token valid with default expiration time(2.hours)" do
      token = LetMeIn::Tokenizer.generate_token
      expect(subject.password_reset_valid?(password_reset_token: token)).to eq(true)
    end

    it "returns false for token invalid with default expiration time(2.hours)" do
      token = ''
      travel_to(3.hours.ago) do
        token = LetMeIn::Tokenizer.generate_token
      end
      expect(subject.password_reset_valid?(password_reset_token: token)).to eq(false)
    end

    it "returns true for token valid with custom expiration time(2.days)" do
      token = ''
      travel_to(1.day.ago) do
        token = LetMeIn::Tokenizer.generate_token
      end
      expect(subject.password_reset_valid?(password_reset_token: token, expiration_time: 2.days)).to eq(true)
    end

    it "returns true for token invalid with custom expiration time(2.days)" do
      token = ''
      travel_to(3.days.ago) do
        token = LetMeIn::Tokenizer.generate_token
      end
      expect(subject.password_reset_valid?(password_reset_token: token, expiration_time: 2.days)).to eq(false)
    end

  end

  context "#update_password_for" do
    let(:new_password) { 'new_secret_password'}
    it "updates password if token belongs to user and is not too old" do
      user.update_attribute(:password_reset_token, LetMeIn::Tokenizer.generate_token)
      token = user.password_reset_token
      old_password_digest = user.password_digest
      expect(
        subject.update_password_for(user: user, password: new_password, password_confirmation: new_password, password_reset_token: token)
      ).to eq(true)
      expect(user.password_digest).to_not eq(old_password_digest)
    end

    it "updates password if token belongs to user and is old" do
      travel_to(3.days.ago) do
        user.update_attribute(:password_reset_token, LetMeIn::Tokenizer.generate_token)
      end
      token = user.password_reset_token
      old_password_digest = user.password_digest
      expect(
        subject.update_password_for(user: user, password: new_password, password_confirmation: new_password, password_reset_token: token)
      ).to eq(true)
      expect(user.password_digest).to_not eq(old_password_digest)
    end

    it "does not update password and returns false if token does not belong to user" do
      user.update_attribute(:password_reset_token, LetMeIn::Tokenizer.generate_token)
      token = LetMeIn::Tokenizer.generate_token
      old_password_digest = user.password_digest
      expect(
        subject.update_password_for(user: user, password: new_password, password_confirmation: new_password, password_reset_token: token)
      ).to eq(false)
      expect(user.password_digest).to eq(old_password_digest)
    end

    it "does not update password and returns false if new password invalid" do
      user.update_attribute(:password_reset_token, LetMeIn::Tokenizer.generate_token)
      token = user.password_reset_token
      old_password_digest = user.password_digest
      expect(
        subject.update_password_for(user: user, password: new_password, password_confirmation: 'password', password_reset_token: token)
      ).to eq(false)
      user.reload
      expect(user.password_digest).to eq(old_password_digest)
    end
  end

end
