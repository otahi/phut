# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec do
  watch(%r{^spec/phuture/.+_spec\.rb$})
  watch(%r{^lib/phuture/(.+)\.rb$})     { |m| "spec/lib/phuture/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
