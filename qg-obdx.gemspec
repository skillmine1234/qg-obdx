$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "qg/obdx/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "qg-obdx"
  s.version     = Qg::Obdx::VERSION
  s.authors     = ["Arvind Janvekar"]
  s.email       = ["apjanvekar@gmail.com"]
  s.homepage    = "http://apibanking.com/"
  s.summary     = "Obdx billpay"
  s.description = "Obdx billpay"
  s.license     = "MIT"

  s.metadata['allowed_push_host'] = 'https://oQrmd9sJbFtYSixtZKSR@gem.fury.io/quantiguous/'

  s.files = Dir["{app,config,db,lib,spec}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.2.2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "gemfury"
end
