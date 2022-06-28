# frozen_string_literal: true

RSpec.describe Halbuilder do
  it "has a version number" do
    expect(Halbuilder::VERSION).not_to be nil
  end

  it "configures things" do
    Halbuilder.configure do |config|
      config.something = "foo"
    end

    expect(Halbuilder.configuration.something).to eq("foo")
  end
end
