$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jump_in/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jump_in"
  s.version     = JumpIn::VERSION
  s.authors     = ["KatarzynaT-B", "moniikag"]
  s.email       = ["kturbiasz@gmail.com", "monikaglier@gmail.com"]
  s.homepage    = "https://github.com/KatarzynaT-B/jump_in"
  s.summary     = "Authentication gem"
  s.description = "JumpIn provides a set of methods that make building login & logout functionality really simple, with only few steps."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.test_files = Dir["spec/**/*"]
end
