# frozen_string_literal: true

RSpec.describe Halbuilder do
  it "configures" do
    Halbuilder.configure { |config| config.link_namespace = "foo" }
    expect(Halbuilder.configuration.link_namespace).to eq("foo")
  end

  it "includes jbuilder extensions" do
    json = Jbuilder.new
    json.hal_link! "foo:bar", "/api/v1/foo/bar"
    expect(json.target!).to eq('{"_links":{"foo:bar":{"href":"/api/v1/foo/bar"}}}')
  end
end
