require 'phut'

When(/^I do phut run "(.*?)"$/) do |file_name|
  @config_file = file_name
  run_opts = "-p #{@pid_dir} -l #{@log_dir} -s #{@socket_dir}"
  step %(I run `phut -v run #{run_opts} #{@config_file}`)
end

Then(/^a vswitch named "(.*?)" should be running$/) do |name|
  expect(system("sudo ovs-vsctl br-exists br#{name}")).to be_truthy
end

Then(/^a vswitch named "(.*?)" should not be running$/) do |name|
  expect(system("sudo ovs-vsctl br-exists br#{name}")).to be_falsey
end

Then(/^a vhost named "(.*?)" launches$/) do |name|
  in_current_dir do
    pid_file = File.join(File.expand_path(@pid_dir), "vhost.#{name}.pid")
    step %(a file named "#{pid_file}" should exist)
  end
end

Then(/^a link is created between "(.*?)" and "(.*?)"$/) do |name_a, name_b|
  in_current_dir do
    link = Phut::Parser.new.parse(@config_file).fetch([name_a, name_b].sort)
    expect(link).to be_up
  end
end
