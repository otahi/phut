require 'active_support/core_ext/class/attribute_accessors'
require 'phut/null_logger'
require 'phut/shell_runner'

module Phut
  # `ip netns ...` command runner
  class Netns
    cattr_accessor(:all, instance_reader: false) { [] }

    def self.create(options, name, logger = NullLogger.new)
      new(options, name, logger).tap { |netns| all << netns }
    end

    def self.each(&block)
      all.each(&block)
    end

    include ShellRunner

    attr_reader :name
    attr_accessor :network_device

    def initialize(options, name, logger)
      @name = name
      @options = options
      @logger = logger
    end

    # rubocop:disable AbcSize
    def run
      sh "sudo ip netns add #{name}"
      sh "sudo ip link set dev #{network_device} netns #{name}"
      sh "sudo ip netns exec #{name} ifconfig lo 127.0.0.1"
      setup_interface
      sh "sudo ip netns exec #{name} route add -net #{net} gw #{gateway}"
    end
    # rubocop:enable AbcSize

    def stop
      sh "sudo ip netns delete #{name}"
    end

    def method_missing(message, *_args)
      @options.__send__ :[], message
    end

    private

    def setup_interface
      if vlan
        sh "sudo ip netns exec #{name}"\
          " ifconfig #{network_device} up"
        sh "sudo ip netns exec #{name}"\
          " ip link add link #{network_device} name"\
          " #{network_device}.#{vlan} type vlan id #{vlan}"
        sh "sudo ip netns exec #{name}"\
          " ifconfig #{network_device}.#{vlan} #{ip} netmask #{netmask}"
        sh "sudo ip netns exec #{name}"\
          " ip link set #{network_device}.#{vlan} address #{mac}" if mac
      else
        sh "sudo ip netns exec #{name}"\
          " ifconfig #{network_device} #{ip} netmask #{netmask}"
        sh "sudo ip netns exec #{name}"\
          " ip link set #{network_device} address #{mac}" if mac
      end
    end
  end
end
