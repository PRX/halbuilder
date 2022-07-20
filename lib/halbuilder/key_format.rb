# frozen_string_literal: true

module Halbuilder::KeyFormat
  class << self
    def setup
      ::Jbuilder.deep_format_keys(true)

      ::Jbuilder.key_format ->(key) do
        key_format = Halbuilder.configuration.key_format
        link_format = Halbuilder.configuration.link_format
        link_key = Halbuilder.configuration.link_key
        embed_key = Halbuilder.configuration.embed_key

        ns = Halbuilder.configuration.link_namespace
        ns_start = "#{ns}_" if ns.present?
        ns_length = ns_start.length if ns.present?

        if key == link_key || key == embed_key
          key
        elsif ns_start && key.start_with?(ns_start)
          format_key("#{ns}:#{key[ns_length..]}", link_format)
        else
          format_key(key, key_format)
        end
      end
    end

    private

    def format_key(key, format)
      if format.nil?
        key
      elsif format == :underscore
        key.underscore
      elsif format == :dasherize
        key.dasherize
      elsif format == :camelize_lower
        key.camelize(:lower)
      elsif format == :camelize_upper
        key.camelize(:upper)
      else
        raise Halbuilder::Error.new("Unknown key format: #{format}")
      end
    end
  end
end
