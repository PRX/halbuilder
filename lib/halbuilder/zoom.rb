# frozen_string_literal: true

module Halbuilder::Zoom
  TRUTHY = [true, "true", "TRUE", 1, "1"]
  FALSEY = [false, "false", "FALSE", 0, "0"]

  def hal_zoomed?(rel, default_setting = false)
    if default_setting.nil?
      true
    elsif zoom_param.nil?
      default_setting
    elsif TRUTHY.include?(zoom_param)
      true
    elsif FALSEY.include?(zoom_param)
      false
    else
      zoom_rels.include?(rel)
    end
  end

  private

  def zoom_param
    @context.params[:zoom]
  end

  def zoom_rels
    zoom_param.is_a?(Array) ? zoom_param : zoom_param.split(",")
  end
end
