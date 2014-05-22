# encoding: utf-8

source 'https://rubygems.org'

# Include dependencies from phut.gemspec. DRY!
gemspec

group :docs do
  gem 'relish', '~> 0.7'
  gem 'yard', '~> 0.8.7.4'
end

group :development do
  gem 'byebug', '~> 3.1.2', platforms: :ruby_20
  gem 'guard', '~> 2.6.1'
  gem 'guard-bundler', '~> 2.0.0'
  gem 'guard-cucumber', '~> 1.4.1'
  gem 'guard-rspec', '~> 4.2.9'
  gem 'guard-rubocop', '~> 1.1.0'
  gem 'pry', '~> 0.9.12.6'
end

group :test do
  gem 'rake'
  gem 'aruba', '~> 0.5.4'
  gem 'codeclimate-test-reporter', require: nil
  gem 'coveralls', '~> 0.7.0', require: false
  gem 'cucumber', '~> 1.3.15'
  gem 'fuubar', '~> 1.3.3'
  gem 'rspec', '~> 2.14.1'
  gem 'rubocop', '~> 0.22.0', platforms: [:ruby_19, :ruby_20, :ruby_21]
end
