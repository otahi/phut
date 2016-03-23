source 'https://rubygems.org'

# Include dependencies from phut.gemspec. DRY!
gemspec development_group: :test

group :doc do
  gem 'relish', require: false
  gem 'yard', '~> 0.8.7.6', require: false
end

group :development do
  gem 'guard', '~> 2.13.0', require: false
  gem 'guard-bundler', '~> 2.1.0', require: false
  gem 'guard-cucumber', '~> 2.0.0', require: false
  gem 'guard-rspec', '~> 4.6.4', require: false
  gem 'guard-rubocop', '~> 1.2.0', require: false
end

group :test do
  gem 'aruba', '~> 0.11.2', require: false
  gem 'codeclimate-test-reporter', require: false
  gem 'coveralls', '~> 0.8.10', require: false
  gem 'cucumber', '~> 2.1.0', require: false
  gem 'flay', '~> 2.6.1', require: false
  gem 'flog', '~> 4.3.2', require: false
  gem 'rake', require: false
  gem 'rspec', '~> 3.4.0', require: false
  gem 'rspec-given', '~> 3.7.1', require: false
  gem 'rubocop', '~> 0.35.1', require: false
  gem 'reek', '~> 3.7.1',
      platforms: [:ruby_21, :ruby_22, :ruby_23], require: false
end
