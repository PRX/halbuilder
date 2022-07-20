# frozen_string_literal: true

RSpec.describe Halbuilder::Embed do
  let(:context) { double("the context", params: {}) }
  let(:json) { Fakebuilder.new(context) }
  let(:result) { JSON.parse(json.target!) }

  it "embeds objects" do
    json.hal_embed! "my:rel" do
      json.title "hello"
    end

    expect(result["_embedded"]).to eq({"my:rel" => {"title" => "hello"}})
  end

  it "embeds collections" do
    json.hal_embed! "my:rel", ["one", "two", "three"] do |num|
      json.title num
    end

    expect(result["_embedded"]).to eq({
      "my:rel" => [
        {"title" => "one"},
        {"title" => "two"},
        {"title" => "three"}
      ]
    })
  end

  it "embeds lambda objects" do
    json.hal_embed! "rel", -> { "value" } do |val|
      json.title "val"
    end

    expect(result["_embedded"]).to eq({"rel" => {"title" => "val"}})
  end

  it "embeds lambda collections" do
    json.hal_embed! "rel", -> { 1..2 } do |n|
      json.title "val#{n}"
    end

    expect(result["_embedded"]).to eq({
      "rel" => [
        {"title" => "val1"},
        {"title" => "val2"}
      ]
    })
  end

  context "with no zoom param" do
    it "does not call lambdas when default is false" do
      json.hal_embed! "my:rel", -> { raise "should not get here" }, zoom: false do
        json.title "title"
      end

      expect(result).to eq({})
    end

    it "does not call blocks when default is false" do
      json.hal_embed! "my:rel", zoom: false do
        raise "should not get here"
      end

      expect(result).to eq({})
    end
  end

  context "when zooming" do
    let(:context) { double("zoomed context", params: {zoom: true}) }

    it "always calls the lambda" do
      json.hal_embed! "my:rel", -> { "value" }, zoom: false do |val|
        json.title val
      end

      expect(result["_embedded"]).to eq({"my:rel" => {"title" => "value"}})
    end

    it "always calls the block" do
      json.hal_embed! "my:rel", zoom: false do
        json.title "value"
      end

      expect(result["_embedded"]).to eq({"my:rel" => {"title" => "value"}})
    end
  end

  context "when un-zooming" do
    let(:context) { double("unzoomed context", params: {zoom: false}) }

    it "never calls the lambda" do
      json.hal_embed! "my:rel", -> { raise "should not get here" }, zoom: true do
        json.title "title"
      end

      expect(result).to eq({})
    end

    it "never calls the block" do
      json.hal_embed! "my:rel", zoom: true do
        raise "should not get here"
      end

      expect(result).to eq({})
    end
  end
end
