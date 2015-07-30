lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pay_with_me/version'

Gem::Specification.new do |gem|
  gem.name          = "pay_with_me"
  gem.version       = PayWithMe::VERSION
  gem.authors       = ["Arthur Borisow"]
  gem.email         = %w( arthur.borisow@gmail.com )
  gem.description   = %q{A gem for e-payment systems API's}
  gem.summary       = %q{A gem for e-payment systems API's}
  gem.homepage      = "https://github.com/arthurborisow/pay_with_me"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w( lib )

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'fuubar'
end
