# frozen_string_literal: true

require_relative "zoom"

module Halbuilder::Helper
  include Halbuilder::Zoom

  def zoom_param
    params[:zoom]
  end
end
