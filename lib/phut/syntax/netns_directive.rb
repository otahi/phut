require 'phut/syntax/directive'

module Phut
  class Syntax
    # The 'netns(name) { ...attributes... }' directive.
    class NetnsDirective < Directive
      attribute :netmask

      def initialize(alias_name, &block)
        @attributes = { name: alias_name, mac: nil, vlan: nil }
        instance_eval(&block)
      end

      def ip(value)
        @attributes[:ip] = value
        @attributes[:name] ||= value
      end

      def route(options)
        @attributes[:net] = options.fetch(:net)
        @attributes[:gateway] = options.fetch(:gateway)
      end

      def mac(value)
        @attributes[:mac] = value
      end

      def vlan(value)
        @attributes[:vlan] = value
      end
    end
  end
end
