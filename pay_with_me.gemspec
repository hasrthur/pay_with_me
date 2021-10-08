# frozen_string_literal: true

require 'English'
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pay_with_me/version'

Gem::Specification.new do |gem|
  gem.name          = 'pay_with_me'
  gem.version       = PayWithMe::VERSION
  gem.authors       = ['Arthur Borisow']
  gem.email         = %w[arthur.borisow@gmail.com]
  gem.description   = "A gem for e-payment systems API's"
  gem.summary       = "A gem for e-payment systems API's"
  gem.homepage      = 'https://github.com/arthurborisow/pay_with_me'
  gem.platform      = Gem::Platform::RUBY
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w[lib]

  gem.required_ruby_version = Gem::Requirement.new('>= 2.7.3')

  gem.add_runtime_dependency 'nokogiri'

  gem.add_development_dependency 'fuubar'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
end
