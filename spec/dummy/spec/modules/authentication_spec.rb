# require_relative '../spec_helper'

# describe LetMeIn do
#   let(:user) { FactoryGirl.create(:user) }

#   class ExampleClass < ActionController::Base
#     include LetMeIn::Authentication
#   end

#   before(:each) do
#     @object = ExampleClass.new
#     allow(@object).to receive(:cookies).and_return(@cookies)
#   end

#   context "log_in" do
#     before(:each) do
#       @cookies = double(:permanent => { } )
#     end

#     it "logs in when correct password given" do
#       @object.login(user, user.password)
#       expect(@cookies.permanent[:user_id]).to eq(user.id)
#     end

#     it "doesn't log in when incorrect password given" do
#       @object.login(user, "wrongpassword")
#       expect(@cookies.permanent[:user_id]).to_not eq(user.id)
#     end
#   end

#   it "logs out" do
#     @cookies = Hash.new { }
#     @cookies[:user_id] = user.id
#     @object.logout
#     expect(@cookies[:user_id]).to eq(nil)
#   end

#   it "sets current user current_user" do
#     @cookies = Hash.new {}
#     @cookies[:user_id] = user.id
#     expect(@object.current_user).to eq(user)
#   end

#   context "logged_in?" do
#     it "returns true if user logged_in" do
#       expect(@object.logged_in?).to eq(false)
#       @cookies = double(:permanent => { } )
#       @object.login(user, user.password)
#       expect(@object.logged_in?).to be_true
#     end

#     it "returns false if user logged_out" do
#       @cookies = Hash.new { }
#       @cookies[:user_id] = user.id
#       expect(@object.logged_in?).to be_true
#       @object.logout
#       expect(@object.logged_in?).to eq(false)
#     end
#   end
# end
