# frozen_string_literal: true

require "jbuilder"

module Halbuilder
  class Configuration
    attr_reader :link_key, :embed_key
    attr_accessor :key_format, :link_namespace, :link_format

    def initialize
      @link_key = "_links"
      @embed_key = "_embedded"
      @key_format = :camelize_lower
      @link_namespace = nil
      @link_format = :dasherize
    end
  end
end
