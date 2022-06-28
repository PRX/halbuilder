# frozen_string_literal: true

require_relative "halbuilder/version"
require_relative "halbuilder/configuration"

module Halbuilder
  class << self
    attr_accessor :configuration

    def configure
      yield configuration
    end
  end

  self.configuration = Configuration.new

  class Error < StandardError; end
end
