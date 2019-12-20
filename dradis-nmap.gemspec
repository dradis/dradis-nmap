$:.push File.expand_path('../lib', __FILE__)
require 'dradis/plugins/nmap/version'
version = Dradis::Plugins::Nmap::VERSION::STRING

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.platform    = Gem::Platform::RUBY
  spec.name        = 'dradis-nmap'
  spec.version     = version
  spec.summary     = 'Nmap add-on for the Dradis Framework.'
  spec.description = 'This add-on allows you to upload and parse output produced from Nmap web server scanner into Dradis.'

  spec.license     = 'GPL-2'

  spec.authors     = ['Daniel Martin']
  spec.email       = ['etd@nomejortu.com']
  spec.homepage    = 'http://dradisframework.org'

  spec.files       = `git ls-files`.split($\)
  spec.executables = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files  = spec.files.grep(%r{^(test|spec|features)/})

  # By not including Rails as a dependency, we can use the gem with different
  # versions of Rails (a sure recipe for disaster, I'm sure), which is needed
  # until we bump Dradis Pro to 4.1.
  # s.add_dependency 'rails', '~> 4.1.1'
  spec.add_dependency 'dradis-plugins', '~> 3.6'
  spec.add_dependency 'ruby-nmap', '~> 0.7'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'combustion', '~> 0.5.2'
end
