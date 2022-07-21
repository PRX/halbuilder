# frozen_string_literal: true

require "jbuilder"
require_relative "halbuilder/configuration"
require_relative "halbuilder/embed"
require_relative "halbuilder/helper"
require_relative "halbuilder/key_format"
require_relative "halbuilder/link"
require_relative "halbuilder/paginate"
require_relative "halbuilder/version"
require_relative "halbuilder/zoom"

module Halbuilder
  class << self
    def reset!
      @configuration = nil
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
      setup
    end

    def setup
      Halbuilder::KeyFormat.setup
    end
  end

  class Error < StandardError; end
end

Halbuilder::KeyFormat.setup
Jbuilder.include Halbuilder::Embed
Jbuilder.include Halbuilder::Link
Jbuilder.include Halbuilder::Paginate
Jbuilder.include Halbuilder::Zoom

# optional rails helpers
if Module.const_defined?(:ActionView)
  ActionView::Base.include(Halbuilder::Helper)
end
if Module.const_defined?(:ActionController)
  ActionController::Base.include(Halbuilder::Helper)
end
