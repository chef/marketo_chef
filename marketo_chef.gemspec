# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marketo_chef/version'

Gem::Specification.new do |spec|
  spec.name          = 'marketo_chef'
  spec.version       = MarketoChef::VERSION
  spec.authors       = ['Trevor Bramble']
  spec.email         = ['tbramble@chef.io']

  spec.summary       = 'Marketo gem with our common uses and error handling'
  spec.homepage      = 'https://github.com/chef/marketo_chef'

  spec.licenses      = [] # closed-source

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://ixnay.ushpay'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday',            '~> 0.12'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.11'

  spec.add_development_dependency 'bundler',  '~> 1.14'
  spec.add_development_dependency 'rake',     '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
