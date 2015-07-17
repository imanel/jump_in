require_relative '../spec_helper.rb'

describe "Sending reset-password-email" do
  let!(:user) { FactoryGirl.create(:user) }

  it "allows user to send reset password link" do
    visit new_password_resets_path
    expect(page).to have_content("Reset Password Page")
    fill_in "email", with: user.email
    click_button "Reset password"
    expect(page).to have_content("Login Page")
  end

end
