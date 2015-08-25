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

  s.test_files = Dir["spec/**/*"]
end
