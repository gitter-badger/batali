$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'batali/version'
Gem::Specification.new do |s|
  s.name = 'batali'
  s.version = Batali::VERSION.version
  s.summary = 'Magic'
  s.author = 'Chris Roberts'
  s.email = 'code@chrisroberts.org'
  s.homepage = 'https://github.com/hw-labs/batali'
  s.description = 'Magic'
  s.require_path = 'lib'
  s.license = 'Apache 2.0'
  s.add_runtime_dependency 'attribute_struct', '~> 0.2.14'
  s.add_runtime_dependency 'grimoire', '~> 0.2.12'
  s.add_runtime_dependency 'bogo', '~> 0.1.20'
  s.add_runtime_dependency 'bogo-cli', '~> 0.1.23'
  s.add_runtime_dependency 'bogo-config', '~> 0.1.10'
  s.add_runtime_dependency 'bogo-ui', '~> 0.1.6'
  s.add_runtime_dependency 'http', '~> 0.8.2'
  s.add_runtime_dependency 'rack-cache'
  s.add_runtime_dependency 'git'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'chef'
  s.executables << 'batali'
  s.files = Dir['{lib,bin}/**/**/*'] + %w(batali.gemspec README.md CHANGELOG.md CONTRIBUTING.md LICENSE)
end
