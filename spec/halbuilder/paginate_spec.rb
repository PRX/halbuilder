# frozen_string_literal: true

RSpec.describe Halbuilder::Paginate do
  let(:request) { double("the request", path: "/123/foo", query_parameters: {}) }
  let(:context) { double("the context", request: request) }
  let(:json) { Fakebuilder.new(context) }
  let(:result) { JSON.parse(json.target!) }

  let(:paged) do
    double("paged thing",
      size: 3,
      total_count: 28,
      prev_page: 2,
      current_page: 3,
      next_page: 4,
      total_pages: 10,
      first_page?: false,
      last_page?: false)
  end

  it "ignores non-paginated collections" do
    json.hal_paginate! []
    expect(result).to eq({})
  end

  it "renders counts and totals" do
    json.hal_paginate! paged

    expect(result["count"]).to eq(3)
    expect(result["total"]).to eq(28)
  end

  it "renders first page links" do
    allow(paged).to receive(:current_page) { 1 }
    allow(paged).to receive(:next_page) { 2 }
    allow(paged).to receive(:first_page?) { true }
    json.hal_paginate! paged

    expect(result["_links"]["first"]).to eq(nil)
    expect(result["_links"]["prev"]).to eq(nil)
    expect(result["_links"]["next"]).to eq({"href" => "/123/foo?page=2"})
    expect(result["_links"]["last"]).to eq({"href" => "/123/foo?page=10"})
  end

  it "renders middle page links" do
    json.hal_paginate! paged

    expect(result["_links"]["first"]).to eq({"href" => "/123/foo"})
    expect(result["_links"]["prev"]).to eq({"href" => "/123/foo?page=2"})
    expect(result["_links"]["next"]).to eq({"href" => "/123/foo?page=4"})
    expect(result["_links"]["last"]).to eq({"href" => "/123/foo?page=10"})
  end

  it "renders last page links" do
    allow(paged).to receive(:prev_page) { 9 }
    allow(paged).to receive(:current_page) { 10 }
    allow(paged).to receive(:last_page?) { true }
    json.hal_paginate! paged

    expect(result["_links"]["first"]).to eq({"href" => "/123/foo"})
    expect(result["_links"]["prev"]).to eq({"href" => "/123/foo?page=9"})
    expect(result["_links"]["next"]).to eq(nil)
    expect(result["_links"]["last"]).to eq(nil)
  end

  it "preserves non-page query parameters" do
    allow(request).to receive(:query_parameters) { {"foo" => "bar", "page" => 1234, "per" => 3} }
    json.hal_paginate! paged

    expect(result["_links"]["first"]).to eq({"href" => "/123/foo?foo=bar&per=3"})
    expect(result["_links"]["prev"]).to eq({"href" => "/123/foo?foo=bar&page=2&per=3"})
    expect(result["_links"]["next"]).to eq({"href" => "/123/foo?foo=bar&page=4&per=3"})
    expect(result["_links"]["last"]).to eq({"href" => "/123/foo?foo=bar&page=10&per=3"})
  end
end
