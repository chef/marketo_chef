# frozen_string_literal: true

# Copyright 2018 Chef Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marketo_chef/version'

Gem::Specification.new do |spec|
  spec.name     = 'marketo_chef'
  spec.version  = MarketoChef::VERSION
  spec.authors  = ['Trevor Bramble']
  spec.email    = ['tbramble@chef.io']

  spec.summary  = 'Marketo API client for our common uses and error handling'
  spec.homepage = 'https://github.com/chef/marketo_chef'

  spec.licenses = ['Apache-2.0']

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # This gem needs to be compatible with OmniAuth (used on the Learn Chef site)
  # which depends on the OAuth2 gem, which requires faraday ['>= 0.8', '< 0.12']
  # https://github.com/intridea/oauth2/blob/v1.3.1/oauth2.gemspec
  spec.add_runtime_dependency 'faraday',            '~> 0.11.0'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.11'

  spec.add_development_dependency 'bundler',            '~> 1.14'
  spec.add_development_dependency 'minitest',           '~> 5.10'
  spec.add_development_dependency 'rake',               '~> 12.0'
  spec.add_development_dependency 'rspec-expectations', '~> 3.6'
  spec.add_development_dependency 'rubocop',            '~> 0.48'
  spec.add_development_dependency 'travis',             '~> 1.8'
end
