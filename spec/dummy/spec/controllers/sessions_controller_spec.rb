# require_relative '../spec_helper.rb'

# describe SessionsController do
#   let!(:user) { FactoryGirl.create(:user) }
#   let(:valid_session) { { user_id: user.id} }
#   subject(:service) { described_class.new() }

#   context "POST create" do
#     it "sets cookies[:user_id] if valid user params given, redirects" do
#       post :create, { session: { email: user.email, password: user.password} }
#       expect(cookies.signed[:user_id]).to eq(user.id)
#       expect(response.status).to be(302)
#     end

#     it "calls login method" do
#       expect(controller).to receive(:login).exactly(1).times
#       post :create, { session: { email: user.email, password: user.password} }
#     end

#     it "doesn't set cookies[:user_id] if invalid user params given, renders new" do
#       post :create, { session: { email: user.email, password: "wrong_password"} }
#       expect(cookies.signed[:user_id]).to be_nil
#       expect(response).to render_template(:new)
#     end
#   end

#   context "DELETE destroy" do
#     it "sets cookies[:user_id] to nil" do
#       cookies.signed[:user_id] = user.id
#       expect([cookies.signed[:user_id]]).to eq([user.id])
#       delete :destroy
#       expect([cookies.signed[:user_id]]).to eq([nil])
#     end
#   end

# end
