module LetMeIn
  module PasswordReset
    def create_password_reset_for(user:, mailer: UserMailer)
      set_password_reset(user)
      send_password_reset_email(user, mailer)
      # ustawia atrybuty do resetu
      # wysyła maila (mail jest z linkiem do edycji i w paramsach przekazuje token)
    end

    def update_password_reset_for(user:, email:, password:, password_confirmation:, reset_token:, token_valid_for: 2.hours )
      if  user.email == email &&
          user.reset_digest == reset_token &&
          !password_reset_expired?(user, token_valid_for)       # zmiana na password_reset_valid? ??
        user.update_attributes(password: password, password_confirmation: password_confirmation, reset_digest: nil)
      end
      # => funkcja zwróci nil jak update się nie powiedzie, np. ze względu na walidacje
      # sprawdza, czy token wciąż ważny
      # sprawdza, czy email i token należą do jednego usera
      # i jeśli tak, zmienia hasło
    end

    def set_password_reset(user)
      klass = user.class
      reset_token = String.new
      loop do
        reset_token = LetMeIn::Tokenizer.call
        break if klass.where(reset_digest: reset_token).first == nil
      end
      user.update_attributes(reset_digest: reset_token, reset_sent_at: Time.now)
      # ustaw reset_digest (wykorzystując Tokenizer,
      # tu trzeba pamiętać o sprawdzeniu, czy nie istnieje już użytkownik z takim stringiem przypisanym;
      # nie możemy się tu odwołać się bezpośrednio do klasy User - bo ona może się nazywać inaczej)
      # ustaw reset_sent_at
    end

    def send_password_reset_email(user, mailer)
      mailer.password_reset(user).deliver
      # zakładamy na razie, że mailer będzie gotowy w aplikacji i będzie miał metodę password_reset
    end

    def password_reset_expired?(user, token_valid_for)
      user.reset_sent_at < Time.now - token_valid_for
      # default ma być taki, że token jest ważny przez dwie godziny
    end
  end
end
