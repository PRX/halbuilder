# frozen_string_literal: true

RSpec.describe Halbuilder::KeyFormat do
  let(:json) { Jbuilder.new }
  let(:result) { JSON.parse(json.target!) }

  describe "#key_format" do
    let(:formatted_key) do
      json.foo_bar_baz "value"
      result.keys.first
    end

    it "does no formatting" do
      Halbuilder.configuration.key_format = nil
      expect(formatted_key).to eq("foo_bar_baz")
    end

    it "underscores keys" do
      Halbuilder.configuration.key_format = :underscore
      expect(formatted_key).to eq("foo_bar_baz")
    end

    it "dasherizes keys" do
      Halbuilder.configuration.key_format = :dasherize
      expect(formatted_key).to eq("foo-bar-baz")
    end

    it "camelize-lowers keys" do
      Halbuilder.configuration.key_format = :camelize_lower
      expect(formatted_key).to eq("fooBarBaz")
    end

    it "camelize-uppers keys" do
      Halbuilder.configuration.key_format = :camelize_upper
      expect(formatted_key).to eq("FooBarBaz")
    end
  end

  it "does not format links" do
    json._links "the-links"
    expect(result).to eq({"_links" => "the-links"})
  end

  it "does not format embeds" do
    json._embedded "the-embeds"
    expect(result).to eq({"_embedded" => "the-embeds"})
  end

  it "formats namespaced link keys" do
    Halbuilder.configuration.link_namespace = "foo"
    Halbuilder.configuration.link_format = :dasherize

    json.foo_some_link "value"
    expect(result).to eq({"foo:some-link" => "value"})
  end

  it "uses normal formatting on unknown namespaces" do
    Halbuilder.configuration.link_namespace = "bar"
    Halbuilder.configuration.link_format = :dasherize

    json.foo_some_link "value"
    expect(result).to eq({"fooSomeLink" => "value"})
  end
end
