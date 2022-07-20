# frozen_string_literal: true

RSpec.describe Halbuilder::Link do
  let(:json) { Jbuilder.new }
  let(:result) { JSON.parse(json.target!) }

  it "renders string links" do
    json.hal_link! "foo:bar", "/api/v1/foo"
    expect(result["_links"]).to eq({
      "foo:bar" => {
        "href" => "/api/v1/foo"
      }
    })
  end

  it "raises an error on unknown links" do
    expect {
      json.hal_link! "foo:bar", double("bad argument")
    }.to raise_error(Halbuilder::Error, /Invalid hal link/)
  end

  it "yields to a block" do
    json.hal_link! "self" do
      json.href "/api/v1/self"
      json.title "what-eva"
      json.foo "bar"
    end

    expect(result["_links"]).to eq({
      "self" => {
        "foo" => "bar",
        "href" => "/api/v1/self",
        "title" => "what-eva"
      }
    })
  end

  it "can render an array" do
    json.hal_link! "self" do
      json.array! 1..3 do |num|
        json.href "/api/v1/#{num}"
      end
    end

    expect(result["_links"]).to eq({
      "self" => [
        {"href" => "/api/v1/1"},
        {"href" => "/api/v1/2"},
        {"href" => "/api/v1/3"}
      ]
    })
  end
end
