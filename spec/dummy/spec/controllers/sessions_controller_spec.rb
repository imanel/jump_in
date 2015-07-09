require_relative '../spec_helper.rb'

describe SessionsController do
  let!(:user) { FactoryGirl.create(:user) }
  let(:valid_session) { { user_id: user.id} }

  context "POST create" do
    it "sets cookies[:user_id]" do
      post :create, { session: { email: user.email, password: user.password} }
      expect(response.status).to be(200)
      expect(cookies[:user_id]).to eq(user.id)
    end
  end

  context "DELETE destroy" do
    it "sets cookies[:user_id] to nil" do
      cookies[:user_id] = user.id
      expect([cookies[:user_id]]).to eq([user.id])
      delete :destroy
      expect([cookies[:user_id]]).to eq([nil])
    end
  end

end
