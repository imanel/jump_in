# require_relative '../spec_helper.rb'

# describe "Logging in" do
#   let!(:user) { FactoryGirl.create(:user) }

#   it "allows user to log in and visit Users#show" do
#     visit 'login'
#     expect(page).to have_content("Login Page")
#     fill_in "session_email", with: user.email
#     fill_in "session_password", with: user.password
#     click_button "Log in"
#     expect(page).to have_content("Show view for user")

#     click_link "Log out"
#     expect(page).to have_content("Login Page")
#   end

# end
