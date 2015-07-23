module LetMeIn
  module PasswordReset
    def create_password_reset_for(user:, mailer: UserMailer)
      set_password_reset(user)
      send_password_reset_email(user, mailer)
      # ustawia atrybuty do resetu
      # wysyła maila (mail jest z linkiem do edycji i w paramsach przekazuje token)
    end

    def update_password_reset_for(user:, password:, password_confirmation:, reset_token:, token_valid_for: 2.hours )
      if user.password_reset_token == reset_token && password_reset_still_valid?(user, token_valid_for)
        user.update_attributes(password: password, password_confirmation: password_confirmation, password_reset_token: nil)
      end
      # => funkcja zwróci nil jak update się nie powiedzie, np. ze względu na walidacje
      # sprawdza, czy token wciąż ważny
      # sprawdza, czy email i token należą do jednego usera
      # i jeśli tak, zmienia hasło
    end

    def set_password_reset(user)
      reset_token = loop do
        token = LetMeIn::Tokenizer.new().generate_token
        break token unless user.class.where(password_reset_token: token).exists?
      end
      user.update_attribute(:password_reset_token, reset_token)
      # ustaw password_reset_token (wykorzystując Tokenizer,
      # tu trzeba pamiętać o sprawdzeniu, czy nie istnieje już użytkownik z takim stringiem przypisanym;
      # nie możemy się tu odwołać się bezpośrednio do klasy User - bo ona może się nazywać inaczej)
      # ustaw reset_sent_at
    end

    def send_password_reset_email(user, mailer)
      mailer.password_reset(user).deliver
      # zakładamy na razie, że mailer będzie gotowy w aplikacji i będzie miał metodę password_reset
    end

    def password_reset_still_valid?(user, token_valid_for)
      token_datetime = LetMeIn::Tokenizer.new(user.password_reset_token).decode_time
      token_datetime > Time.now - token_valid_for
      # default ma być taki, że token jest ważny przez dwie godziny
    end
  end
end
