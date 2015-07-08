module LetMeIn
  module PasswordReset

    def create_password_reset_for(user:, mailer:)
      # ustawia atrybuty do resetu
      # wysyła maila (mail jest z linkiem do edycji i w paramsach przekazuje token)
    end

    def update_password_reset_for(user:, password:, password_confimration:, password_reset_token:, email:)
      # sprawdza, czy token wciąż ważny
      # sprawdza, czy email i token należą do jednego usera
       # i jeśli tak, zmienia hasło
    end

    def set_password_reset(user)
      # ustaw reset_digest (wykorzystując Tokenizer, tu trzeba pamiętać o sprawdzeniu,
      # czy nie istnieje już użytkownik z takim stringiem przypisanym; nie możemy się tu
      # odwołać się bezpośrednio do klasy User - bo ona może się nazywać inaczej)
      # ustaw reset_sent_at
    end

    def send_password_reset_email(user, mailer)
      # zakładamy na razie, że mailer będzie gotowy w aplikacji i będzie miał metodę password_reset
    end

    def password_reset_expired?(user)
      # default ma być taki, że token jest ważny przez dwie godziny
    end
  end
end
