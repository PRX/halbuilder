# frozen_string_literal: true

module Halbuilder::Paginate
  def hal_paginate!(collection)
    return unless paginated?(collection)

    set!("count", collection.size)
    set!("total", collection.total_count)
    _links do
      hal_paginate_links!(collection)
    end
  end

  def hal_paginate_links!(rel)
    set!("first", page_href(1)) unless rel.first_page?
    set!("prev", page_href(rel.prev_page)) unless rel.first_page?
    set!("next", page_href(rel.next_page)) unless rel.last_page?
    set!("last", page_href(rel.total_pages)) unless rel.last_page?
  end

  private

  def paginated?(rel)
    if rel
      rel.respond_to?(:current_page) && rel.respond_to?(:total_pages)
    end
  end

  def page_href(num)
    query =
      if num == 1
        @context.request.query_parameters.except("page")
      else
        @context.request.query_parameters.tap { |q| q["page"] = num }
      end

    query_str = ::URI.encode_www_form(query)
    if query_str.present?
      {href: "#{@context.request.path}?#{query_str}"}
    else
      {href: @context.request.path}
    end
  end
end
