require_relative '../spec_helper'

class AuthenticationController < ActionController::Base
  include LetMeIn::Authentication
end

describe AuthenticationController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  context "#fullstack_login" do
    it "returns false if user logged_in" do
      allow(subject).to receive(:logged_in?).and_return(true)
      expect(subject.fullstack_login(user: user, password: user.password)).to eq(false)
    end

    it "returns false if user not logged_in but authentication fails" do
      allow(subject).to receive(:logged_in?).and_return(false)
      allow(subject).to receive(:authenticate_user).with(user:user, password:'something').and_return(false)
      expect(subject.fullstack_login(user: user, password:'something')).to eq(false)
    end

    it "returns true if user not logged_in and authentication successful" do
      allow(subject).to receive(:logged_in?).and_return(false)
      allow(subject).to receive(:authenticate_user).and_return(true)
      allow(subject).to receive(:login).and_return(true)
      expect(subject.fullstack_login(user: user, password: user.password)).to eq(true)
    end

    context 'when user not logged_in and authentication successful' do
      it "calls 'login' with permanent=false for permanent false by default" do
        allow(subject).to receive(:logged_in?).and_return(false)
        allow(subject).to receive(:authenticate_user).with(user:user, password:user.password).and_return(true)
        expect(subject).to receive(:login).with(user:user, permanent:false).exactly(1).times.and_return(true)
        subject.fullstack_login(user: user, password: user.password)
      end

      it "calls 'login' with permanent=false for permanent passed as false" do
        allow(subject).to receive(:logged_in?).and_return(false)
        allow(subject).to receive(:authenticate_user).with(user:user, password:user.password).and_return(true)
        expect(subject).to receive(:login).with(user:user, permanent:false).exactly(1).times.and_return(true)
        subject.fullstack_login(user: user, password: user.password, permanent: false)
      end

      it "calls 'login' with permanent=true for permanent passed as true" do
        allow(subject).to receive(:logged_in?).and_return(false)
        allow(subject).to receive(:authenticate_user).with(user:user, password:user.password).and_return(true)
        expect(subject).to receive(:login).with(user:user, permanent:true).exactly(1).times.and_return(true)
        subject.fullstack_login(user: user, password: user.password, permanent: true)
      end
    end
  end

  context "#login" do
    it "sets session when permanent not passed (default)" do
      subject.login(user: user)
      expect(session[:user_id]).to eq(user.id)
      expect(cookies.signed[:user_id]).to eq(nil)
    end

    it "sets session when permanent passed as false" do
      subject.login(user: user, permanent: false)
      expect(session[:user_id]).to eq(user.id)
      expect(cookies.signed[:user_id]).to eq(nil)
    end

    it "sets cookies when permanent passed as true" do
      subject.login(user: user, permanent: true)
      expect(cookies.signed[:user_id]).to eq(user.id)
      expect(session[:user_id]).to eq(nil)
    end
  end

  context "#authenticate_user" do
    let(:wrong_password)   { 'wrong password' }
    let(:correct_password) { 'correct password' }

    before(:each) do
      allow(user).to receive(:authenticate).with(correct_password).and_return(true)
      allow(user).to receive(:authenticate).with(wrong_password).and_return(false)
    end

    it "returns true if correct password given" do
      expect(subject.authenticate_user(user: user, password: wrong_password)).to eq(false)
    end

    it "returns false if wrong password is given" do
      expect(subject.authenticate_user(user: user, password: wrong_password)).to eq(false)
    end
  end

  context "#logout" do
    it "clears :user_id in session when session set" do
      session[:user_id] = user.id
      expect {
        subject.logout
      }.to change{ session[:user_id] }.from(user.id).to(nil)
    end

    it "clears :user_id in cookies when cookies set" do
      cookies.permanent.signed[:user_id] = user.id
      expect {
        subject.logout
      }.to change{ cookies.permanent.signed[:user_id] }.from(user.id).to(nil)
    end

    it "returns true if logged out from session" do
      session[:user_id] = user.id
      expect(subject.logout).to eq(true)
    end

    it "returns true if logged out from cookies" do
      cookies.permanent.signed[:user_id] = user.id
      expect(subject.logout).to eq(true)
    end

    it "returns true if logged out from empty session & cookies" do
      expect(subject.logout).to eq(true)
    end
  end

  context "#current_user" do
    it "returns user based on session" do
      subject.session[:user_id] = user.id
      expect(subject.current_user).to eq(user)
    end

    it "returns user based on cookies" do
      cookies.signed[:user_id] = user.id
      expect(subject.current_user).to eq(user)
    end

    it "returns nil when session and cookie empty" do
      expect(subject.current_user).to eq(nil)
    end
  end

  context "#logged_in?" do
    it "returns true if current user is set in session" do
      session[:user_id] = user.id
      expect(subject.logged_in?).to eq(true)
    end

    it "returns true if current user is set in cookies" do
      cookies.permanent.signed[:user_id] = user.id
      expect(subject.logged_in?).to eq(true)
    end

    it "returns false if no current user" do
      expect(subject.logged_in?).to eq(false)
    end
  end

  context "#helper_method" do
    it "includes current_user and logged_in?" do
      expect(subject._helper_methods.include? :logged_in?).to eq(true)
      expect(subject._helper_methods.include? :current_user).to eq(true)
    end
  end
end
