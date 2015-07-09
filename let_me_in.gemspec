$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "let_me_in/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "let_me_in"
  s.version     = LetMeIn::VERSION
  s.authors     = ["KatarzynaT-B", "moniikag"]
  s.email       = ["kturbiasz@gmail.com", "monikaglier@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of LetMeIn."
  s.description = "TODO: Description of LetMeIn."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "sqlite3"
  s.add_dependency 'bcrypt'
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "byebug"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "capybara-webkit"
  s.add_development_dependency "database_cleaner"
end
