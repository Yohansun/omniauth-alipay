# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-alipay/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-alipay"
  s.version     = Omniauth::Alipay::VERSION
  s.authors     = ["Zhen.Sun"]
  s.email       = ["sun@networking.io"]
  s.homepage    = "http://rubygems.org/gems/omniauth-alipay"
  s.summary     = %q{an omniauth strategy for alipay}
  s.description = %q{an omniauth strategy for alipay}

  s.rubyforge_project = "omniauth-alipay"
  s.add_dependency 'omniauth', '~> 1.1.4'
  s.add_dependency 'omniauth-oauth2', '~> 1.1.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end