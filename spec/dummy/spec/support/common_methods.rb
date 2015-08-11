# module Authentication

def set_session(object)
  session[:let_me_in_class] = object.class.to_s
  session[:let_me_in_id] = object.id
end

def set_cookies(object, expires)
  cookies.permanent.signed[:let_me_in_class] = { :value => object.class.to_s, :expires => expires }
  cookies.permanent.signed[:let_me_in_id] = { :value => object.id, :expires => expires }
end

def expect_session_eq(klass:, id:)
  expect(session[:let_me_in_class]).to eq(klass)
  expect(session[:let_me_in_id]).to eq(id)
end

def expect_cookies_eq(klass:, id:)
  expect(cookies.signed[:let_me_in_class]).to eq(klass)
  expect(cookies.signed[:let_me_in_id]).to eq(id)
end

# dummy App

def log_in(email, password)
  fill_in "session_email", with: email
  fill_in "session_password", with: password
  click_button "Log in"
end

