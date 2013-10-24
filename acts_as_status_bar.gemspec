# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
require File.expand_path('../lib/acts_as_status_bar/version', __FILE__)

Gem::Specification.new do |s|
  s.authors          = ["Andrea Bignozzi"]
  s.email            = ["skylord73@gmail.com"]
  s.description      = "Rails StatusBar with ActiveRecord integration, permits dynamic custom output from your model"
  s.summary          = "Rails StatusBar with ActiveRecord integration"
  
  s.files            = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md", "CHANGELOG.md"]
  s.executables      = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files       = s.files.grep(%r{^(test|spec|features)/})
  s.name             = "acts_as_status_bar"
  s.require_paths    = ["lib"]
  s.version          = ActsAsStatusBar::VERSION
  
  s.add_dependency "rails", "~>3.0.15"
  s.add_dependency  "mysql2"
  
end

