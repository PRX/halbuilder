# frozen_string_literal: true

RSpec.describe Halbuilder::Configuration do
  it "has default configurations" do
    expect(Halbuilder.configuration.link_key).to eq("_links")
    expect(Halbuilder.configuration.embed_key).to eq("_embedded")
    expect(Halbuilder.configuration.key_format).to eq(:camelize_lower)
    expect(Halbuilder.configuration.link_namespace).to eq(nil)
    expect(Halbuilder.configuration.link_format).to eq(:dasherize)
  end

  it "overrides configurations" do
    Halbuilder.configure do |config|
      config.key_format = :dasherize
      config.link_namespace = "PRX"
      config.link_format = :camelize_upper
    end

    expect(Halbuilder.configuration.key_format).to eq(:dasherize)
    expect(Halbuilder.configuration.link_namespace).to eq("PRX")
    expect(Halbuilder.configuration.link_format).to eq(:camelize_upper)
  end
end
