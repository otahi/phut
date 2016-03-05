$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rake/clean'

RELISH_PROJECT = 'trema/phut'

task default: :test
task test: [:spec, :cucumber, :quality]
task travis: [:spec, 'cucumber:travis', :quality]

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.1')
  task quality: [:rubocop, :reek, :flog, :flay]
else
  task quality: [:rubocop, :flog, :flay]
end

Dir.glob('tasks/*.rake').each { |each| import each }
