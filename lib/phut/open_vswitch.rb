require 'phut/null_logger'
require 'phut/setting'
require 'phut/shell_runner'

module Phut
  # Open vSwitch controller.
  class OpenVswitch
    include ShellRunner

    attr_reader :dpid
    alias_method :datapath_id, :dpid
    attr_reader :network_devices

    def initialize(dpid, name = nil, logger = NullLogger.new)
      @dpid = dpid
      @name = name
      @network_devices = []
      @logger = logger
    end

    def name
      @name || format('%#x', @dpid)
    end

    def to_s
      "vswitch (name = #{name}, dpid = #{format('%#x', @dpid)})"
    end

    # rubocop:disable MethodLength
    # rubocop:disable AbcSize
    def run
      sh "sudo ovs-vsctl add-br #{bridge_name}"
      sh "sudo /sbin/sysctl -w net.ipv6.conf.#{bridge_name}.disable_ipv6=1 -q"
      @network_devices.each do |each|
        sh "sudo ovs-vsctl add-port #{bridge_name} #{each}"
      end
      sh "sudo ovs-vsctl set bridge #{bridge_name}" \
         " protocols=#{open_flow_protocol}" \
         " other-config:datapath-id=#{dpid_zero_filled}"
      sh "sudo ovs-vsctl set-controller #{bridge_name} tcp:127.0.0.1:6633"\
         " -- set controller #{bridge_name} connection-mode=out-of-band"
      sh "sudo ovs-vsctl set-fail-mode #{bridge_name} secure"
    rescue
      raise "Open vSwitch (dpid = #{@dpid}) is already running!"
    end
    alias_method :start, :run
    # rubocop:enable MethodLength
    # rubocop:enable AbcSize

    def stop
      fail "Open vSwitch (dpid = #{@dpid}) is not running!" unless running?
      sh "sudo ovs-vsctl del-br #{bridge_name}"
    end
    alias_method :shutdown, :stop

    def maybe_stop
      return unless running?
      stop
    end

    def bring_port_up(port_number)
      sh "sudo ovs-ofctl mod-port #{bridge_name} #{port_number} up"
    end

    def bring_port_down(port_number)
      sh "sudo ovs-ofctl mod-port #{bridge_name} #{port_number} down"
    end

    def dump_flows
      `sudo ovs-ofctl dump-flows #{bridge_name}`
    end

    def running?
      system "sudo ovs-vsctl br-exists #{bridge_name}"
    end

    private

    def bridge_name
      'br' + name
    end

    def open_flow_protocol
      'OpenFlow' + { 1 => '10', 4 => '13' }.fetch(Pio::OpenFlow::VERSION)
    end

    def restart
      stop
      start
    end

    def network_device
      "vsw_#{name}"
    end

    def dpid_zero_filled
      hex = format('%x', @dpid)
      '0' * (16 - hex.length) + hex
    end
  end
end
