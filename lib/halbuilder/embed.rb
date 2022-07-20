# frozen_string_literal: true

module Halbuilder::Embed
  def hal_embed!(rel, *args, &block)
    collection = :not_provided
    opts = {}

    # first arg may optionally be an iterable collection
    if args.count > 1
      collection = args[0]
      opts = args[1]
    elsif args[0].is_a?(Hash)
      # NOTE: we don't allow passing a _non_ options hash as the only argument
      opts = args[0]
    elsif args.length > 0
      collection = args[0]
    end

    # check if we're zooming before rendering anything
    if hal_zoomed?(rel, opts[:zoom])
      set! Halbuilder.configuration.embed_key do
        set! rel do
          # only load collection from proc after deciding to zoom
          collection = collection.call if collection.is_a?(Proc)

          # iterate block, or render explicit nulls
          if collection.respond_to?(:each) && !collection.is_a?(Hash)
            array! collection do |c|
              block.call(c)
            end
          elsif collection.present? || collection == :not_provided
            block.call(collection)
          else
            null!
          end
        end
      end
    end
  end
end
