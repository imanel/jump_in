require_relative '../spec_helper.rb'

describe "Resetting password" do
  let!(:user) { FactoryGirl.create(:user) }

  context "Sending reset-password-email" do
    it "allows user to send reset password link" do
      visit new_password_resets_path
      expect(page).to have_content("Reset Password Page")
      fill_in "email", with: user.email
      click_button "Reset password"
      expect(page).to have_content("Login Page")
    end
  end

  context "Following the reset-password-link" do
    it "allows user to update password and redirects to login_path" do
      user.update_attribute(:password_reset_token, LetMeIn::Tokenizer.new(nil).generate_token)
      visit edit_password_resets_path(token: user.password_reset_token)
      expect(page).to have_content("Edit for PasswordReset")
      fill_in "password", with: 'new_password'
      fill_in "password_confirmation", with: 'new_password'
      click_button "Set new password"
      expect(page).to have_content("Login Page")
    end

    it "renders edit if too old token given" do
      user.update_attribute(:password_reset_token, Base64.encode64("#{SecureRandom.hex(10)}.#{5.days.ago}"))
      visit edit_password_resets_path(token: user.password_reset_token)
      expect(page).to have_content("Edit for PasswordReset")
      fill_in "password", with: 'new_password'
      fill_in "password_confirmation", with: 'new_password'
      click_button "Set new password"
      expect(page).to have_content("Edit for PasswordReset")
    end

    it "renders edit if password != password_confirmation" do
      user.update_attribute(:password_reset_token, LetMeIn::Tokenizer.new(nil).generate_token)
      visit edit_password_resets_path(token: user.password_reset_token)
      expect(page).to have_content("Edit for PasswordReset")
      fill_in "password", with: 'new_password'
      fill_in "password_confirmation", with: 'another_password'
      click_button "Set new password"
      expect(page).to have_content("Edit for PasswordReset")
    end
  end
end
