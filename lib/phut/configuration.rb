require 'forwardable'
require 'phut/null_logger'
require 'phut/open_vswitch'

module Phut
  # Parsed DSL data.
  class Configuration
    extend Forwardable

    def_delegators :@all, :fetch, :[]

    def initialize(logger = NullLogger.new)
      @all = {}
      @logger = logger
    end

    def vswitches
      @all.values.select { |each| each.is_a? OpenVswitch }
    end

    def vhosts
      @all.values.select { |each| each.is_a? Vhost }
    end

    def links
      @all.values.select { |each| each.is_a? VirtualLink }
    end

    def run
      links.each(&:run)
      vhosts.each { |each| each.run vhosts }
      vswitches.each(&:run)
    end

    def stop
      vswitches.each(&:maybe_stop)
      vhosts.each(&:maybe_stop)
      links.each(&:maybe_stop)
    end

    def add_vswitch(name, attrs)
      check_name_conflict name
      @all[name] = OpenVswitch.new(attrs[:dpid], name, @logger)
    end

    def add_vhost(name, attrs)
      check_name_conflict name
      @all[name] =
        Vhost.new(attrs[:ip], attrs[:mac], attrs[:promisc], name, @logger)
    end

    def add_link(name_a, name_b, peers)
      @all[[name_a, name_b].sort] =
        VirtualLink.new(name_a, peers.device_a, name_b, peers.device_b, @logger)
    end

    private

    def check_name_conflict(name)
      conflict = @all[name]
      fail "The name #{name} conflicts with #{conflict}." if conflict
    end
  end
end
