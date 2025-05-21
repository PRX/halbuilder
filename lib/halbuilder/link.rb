# frozen_string_literal: true

module Halbuilder::Link
  def hal_link!(rel, val = nil, &block)
    set! Halbuilder.configuration.link_key do
      if block.present?
        set! rel do
          block.call
        end
      elsif val.is_a?(String)
        set! rel do
          href val
        end
      else
        ::Kernel.raise Halbuilder::Error.new("Invalid hal link: #{href.inspect}")
      end
    end
  end
end
