require_relative '../spec_helper.rb'

describe PasswordResetsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:params) { { email: user.email,
    password: 'new_password',
    password_confirmation:'new_password',
    reset_token: user.password_reset_token } }

  context "POST create" do
    it "sets password_reset_token, sends email, redirects to login path" do
      expect {
        post :create, { email: user.email, use_route: :password_resets }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
      user.reload
      expect(user.password_reset_token).to_not be_nil
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
      user.update_attributes(password_reset_token: LetMeIn::Tokenizer.new(nil).generate_token)
    }

    it "allows user to update password and redirects to login_path" do
      patch :update, params.merge( { use_route: :password_resets} )
      expect(response.status).to be(302)
      expect(response).to redirect_to(login_path)
    end

    it "renders edit for token too old" do
      user.update_attribute(:password_reset_token, Base64.encode64("#{SecureRandom.hex(10)}.#{5.days.ago}"))
      user.reload
      patch :update, params.merge( { use_route: :password_resets} )
      expect(response.status).to be(200)
      expect(response).to render_template(:edit)
    end

    it "renders edit for password != password_confirmation" do
      inv_params = params.dup
      inv_params[:password_confirmation] = "another_password"
      patch :update, inv_params.merge( { use_route: :password_resets} )
      expect(response.status).to be(200)
      expect(response).to render_template(:edit)
    end
  end

end
