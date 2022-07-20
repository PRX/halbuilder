# frozen_string_literal: true

RSpec.describe Halbuilder::Zoom do
  let(:context) { double("the context", params: {zoom: ["rel1"]}) }
  let(:json) { Fakebuilder.new(context) }
  let(:result) { JSON.parse(json.target!) }

  it "always zooms without a default" do
    expect(json.hal_zoomed?("rel1", nil)).to eq(true)
    expect(json.hal_zoomed?("rel2", nil)).to eq(true)
    expect(json.hal_zoomed?("rel3", nil)).to eq(true)
  end

  it "returns the default with no zoom query param" do
    allow(context).to receive(:params) { {zoom: nil} }

    expect(json.hal_zoomed?("rel1", true)).to eq(true)
    expect(json.hal_zoomed?("rel1", false)).to eq(false)
  end

  it "zooms all" do
    [true, "true", "TRUE", 1, "1"].each do |z|
      allow(context).to receive(:params) { {zoom: z} }

      expect(json.hal_zoomed?("rel1", false)).to eq(true)
      expect(json.hal_zoomed?("rel2", false)).to eq(true)
      expect(json.hal_zoomed?("rel3", false)).to eq(true)
    end
  end

  it "zooms none" do
    [false, "false", "FALSE", 0, "0"].each do |z|
      allow(context).to receive(:params) { {zoom: z} }

      expect(json.hal_zoomed?("rel1", true)).to eq(false)
      expect(json.hal_zoomed?("rel2", true)).to eq(false)
      expect(json.hal_zoomed?("rel3", true)).to eq(false)
    end
  end

  it "zooms specific rels" do
    allow(context).to receive(:params) { {zoom: ["foo", "rel1", "rel3"]} }

    expect(json.hal_zoomed?("rel1", true)).to eq(true)
    expect(json.hal_zoomed?("rel2", true)).to eq(false)
    expect(json.hal_zoomed?("rel3", true)).to eq(true)
  end

  it "zooms comma-separated rels" do
    allow(context).to receive(:params) { {zoom: "foo,rel1,rel3"} }

    expect(json.hal_zoomed?("rel1", true)).to eq(true)
    expect(json.hal_zoomed?("rel2", true)).to eq(false)
    expect(json.hal_zoomed?("rel3", true)).to eq(true)
  end
end
