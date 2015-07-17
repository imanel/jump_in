require_relative '../spec_helper.rb'

describe PasswordResetsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:params) { { email: user.email,
    password: 'new_password',
    password_confirmation:'new_password',
    token: user.reset_digest } }

  context "POST create" do
    it "sets reset_digest, sends email, redirects to login path" do
      expect {
        post :create, { email: user.email, use_route: :password_resets }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
      user.reload
      expect(user.reset_digest).to_not be_nil
      expect(response.status).to be(302)
      expect(response).to redirect_to(login_path)
    end

    it "raises an error if user not found" do
      expect {
        post :create, { password_reset: { email: 'email' }, use_route: :password_resets }
      }.to raise_error(NoMethodError)
    end
  end

  context "PATCH update" do
    before(:each) {
      user.update_attributes(reset_digest: LetMeIn::Tokenizer.call,
        reset_sent_at: Time.now )
    }

    it "allows user to update password and renders nothing" do
      patch :update, { user: params, use_route: :password_resets }
      expect(response.status).to be(200)
      expect(response.body).to be_blank
      expect(response).to_not render_template(:edit)
    end

    it "renders edit for token too old" do
      user.update_attribute(:reset_sent_at, 2.day.ago)
      user.reload
      patch :update, { user: params, use_route: :password_resets }
      expect(response.status).to be(200)
      expect(response).to render_template(:edit)
    end

    it "renders edit for invalid password" do
      inv_params = params.dup
      inv_params[:token] = LetMeIn::Tokenizer.call
      patch :update, { user: inv_params, use_route: :password_resets }
      expect(response.status).to be(200)
      expect(response).to render_template(:edit)
    end
  end

end
