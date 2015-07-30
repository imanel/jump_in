def log_in(email, password)
  fill_in "session_email", with: email
  fill_in "session_password", with: password
  click_button "Log in"
end
