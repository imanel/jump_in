# LetMeIn

LetMeIn provides a set of methods that make building login & logout functionality really simple, with only few steps. It takes care of setting cookies or session and has it's own tokenizer. Moreover, it allows to choose authentication strategy which fits your application the best.

## Links:
- [Source Code]()
- Source Code


## Installation
```
gem 'let_me_in'
```
Don't forget to run:
```
bundle install
```
In order to use LetMeIn you need to include modules of your choice in `application_controller.rb` or in a controller responsible for a particular functionality. For example in case of logging in with password and using password reset functionality you'll need:
```
class ApplicationController < ActionController::Base
  include LetMeIn::Authentication
  include LetMeIn::PasswordReset
end
```
Here is a complete list of modules that LetMeIn provides:
* `LetMeIn::Authentication`
* `LetMeIn::PasswordReset`
* `LetMeIn::Tokenizer` (included by default when `LetMeIn::PasswordReset` is included)


## Authentication
```
include LetMeIn::Authentication
```
This module provides complex `let_me_in` method, two basic methods: `login` and `let_me_out`, as well as two helper methods: `current_user` and `logged_in?` and extracted methods to be used according to your own preferences.
```
let_me_in(user:, permanent: false, expires: nil, **params)
```
authenticates object and loggs it in (using `login` method). The authentication strategy depends on the passed params (detaild description below).
```
login(user:, permanent: false, expires: nil)
```
sets session for the given user (object) if `permanent` is not passed or is passed as `false`, e.g. `login(user: @student)`.

It sets `cookies.signed` if `permanent` is passed as `true`. Default expiration time is set to 20 years (same as `cookies.permanent`). It is also possible to set custom expiration time for the cookies, e.g. `login(user: @student, permanent: true, expires: 24.hours)`.

If you're not using the comprehensive method `let_me_in`, it is suggested to use `login` method as follows: `login(user: @student) unless logged_in?`
```
let_me_out
```
logs out user (it clears session or cookies depending on the previous choice of login strategy). It takes no arguments.

* `current_user` - returns object that is currently logged in (`nil` otherwise),
* `logged_in?` - returns `true` if any object is logged in (by means of the above mentioned login method). Otherwise it returns `false`,

* `authenticate_by_strategy(user:, params:)` - returns result of strategy-authentication, returns `false` if strategy is not detected. All params needed for authentication need to be passed as hash, e.g. `authenticate_by_strategy(user: @student, params: { password: 'password'} )`,
* `set_cookies(user:, expires:)` - sets `cookies.signed`. Default expiration time is set to 20 years as in `cookies.permanent`. You can pass your custom expiration time,
* `set_session(user:)` - sets session,
* `delete_cookies` - clears cookies set by `set_cookies`,
* `delete_session` - clears session set by `set_session`.


#### Authentication Strategies
At the moment LetMeIn provides one strategy: `ByPassword`. Strategy `ByOmniAuth` is in progress, strategy `ByToken` is in our minds, other strategies are more then welcome to come from your suggestions!


#### Authentication by password
LetMeIn authentication by password uses `has_secure_password`'s authenticate method. Therefore you need to add column `password_digest` to your model's tabel and add: `has_secure_password` in the model to be authenticated. For example:
```
class YourClassName < ActiveRecord::Base
  has_secure_password
end
```
This strategy is being used when params passed to `let_me_in` or `authenticate_by_strategy` include `:password`, therefore you should use it this way:
```
let_me_in(user: @student, permanent: true, expires: 30.days, password: params[:password])
```
What you need to pass is the object to be authenticated (and logged in), password received in params and optionally: `permanent` and `expires` parameters (as explained in `login` method description).

As for the second method you should use it this way, passing the password in a hash (`params`):
```
authenticate_by_strategy(user: @student, params: { password: params[:password] })
```



#### Authentication by OmniAuth
In order to log in with OmniAuth authentication you have to find (or create) the object by means of OmniAuth and then simply use `login` method as descirbed above. For example:
```
@student = Student.from_omniauth(request.env['omniauth.auth'])
if @student
  login(user: @student, permanent: true)
else
  ...
end
```


## Password Reset
```
include LetMeIn::PasswordReset
```
This functionality requires two columns in your model's table: `password_digest` and `letmein_reset_token`. With these attributes your application is ready to use the following methods:
* `set_password_reset_for`
* `set_token`
* `generate_unique_token_for`
* `token_uniq?`
* `password_reset_valid?`
* `update_password_for`
* `token_correct?`

Of course you won't have to use all of them by yourself. Everything depends on your preferences.
There are two main and comprehensive methods that cover most of the work: `set_password_reset_for` and `update_password_for`. The rest are just methods extracted in order to let you build your own, custom functionality.
```
set_password_reset_for(user:, token: nil)
```
takes one required argument: an object that the password reset is performed for, passed as a named parameter `user` (for example: `set_password_reset_for(user: @student)`) and sets a unique token as the object's attribute `letmein_reset_token`. The token is generated by `LetMeIn::Tokenizer` described below.

If the optional parameter is passed (`token`, e.g. `set_password_reset_for(user: @user, token: your_token)`) the method checks uniqueness of the given token and sets it as the object's `letmein_reset_token`. It returns `false` if the given token is not unique.

The subsidiary methods are:
* `set_token(user:, token:)` - updates object's attribute `letmein_reset_token` to the given token, does not check it's uniqueness,
* `generate_unique_token_for(user:)` - generates unique token by means of `LetMeIn::Tokenizer`, the token is unique in scope of the passed object's class,
* `token_uniq?(user:, token:)` - checks uniqueness of the given token in scope of the passed object's class.

```
password_reset_valid?(password_reset_token:, expiration_time: 2.hours)
```
checkes wheather the given token is still valid (has not expired). Returns `true` or `false`. Default expiration time is 2 hours. You can pass any custom value of your choice as well. This method is suitable for any token generated with `LetMeIn::Tokenizer`.
```
update_password_for(user:, password:, password_confirmation:, password_reset_token:)
```
verifies correctness of the given token (it's identity with the object's `letmein_reset_token`) and updates object's `password_digest`. Returns `false` if the token is incorrect.

Suggested usage is: (unless expiration time for tokens is not what you need)
```
if password_reset_valid?(password_reset_token: token)
  update_password_for(user: user, password: password, password_confirmation: password_confirmation, password_reset_token: token)
else
  ...
end
```
And the subsidiary method:
* `token_correct?(user_token:, received_token:)` - verifies identity if the object's token and the received token, e.g. `token_correct?(user_token: @student.letmein_reset_token, received_token: params[:token]`.


## Tokenizer
```
include LetMeIn::Tokenizer
```
As mentioned above, this module is included by default with the password reset functionality. Thus in most cases there is no need to include it explicitly. However, in case your application doesn't use the password reset functionality but it needs the tokenizer somewhere else, you're free to include this module seperately.
`LetMeIn::Tokenizer` provides two methods that you might need: `LetMeIn::Tokenizer.generate_token` and `LetMeIn::Tokenizer.decode_time`.
* `LetMeIn::Tokenizer.generate_token`
 generates safe token by means of `Base64` & `SecureRandom`. It contains encrypted token generation time.
* `LetMeIn::Tokenizer.decode_time(token)`
 decodes the token generation time from the token. It takes single parameter (that is the `token`) and returns a `datetime` object. It can be used to verify wheather the token is still valid (has not expired).
