require_relative '../spec_helper.rb'

describe UsersController do
  let!(:user) { FactoryGirl.create(:user) }
  let(:valid_session) { { user_id: user.id} }

  context "GET show" do
    it "renders nothing if user not signed in" do
      get :show, use_route: :users
      expect(response.status).to be(401)
      expect(response.body).to be_blank
    end

    it "renders template show if user signed in" do
      get :show, { id: user.id, use_route: :users }, valid_session
      expect(response.status).to be(200)
    end
  end

end
