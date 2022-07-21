# frozen_string_literal: true

class FakeController
  include Halbuilder::Helper
  attr_accessor :params
end

RSpec.describe Halbuilder::Helper do
  let(:controller) do
    c = FakeController.new
    c.params = {}
    c
  end

  it "checks default zooms" do
    expect(controller.hal_zoomed?("some:rel", nil)).to eq(true)
    expect(controller.hal_zoomed?("some:rel", true)).to eq(true)
    expect(controller.hal_zoomed?("some:rel", false)).to eq(false)

    # default_zoom=false is the default
    expect(controller.hal_zoomed?("some:rel")).to eq(false)
  end

  it "checks the zoom param" do
    controller.params[:zoom] = "some:rel"

    expect(controller.hal_zoomed?("some:rel")).to eq(true)
    expect(controller.hal_zoomed?("other:rel")).to eq(false)
  end
end
