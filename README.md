# Halbuilder

[![license](https://img.shields.io/github/license/PRX/halbuilder.svg)](LICENSE)
[![Gem](https://img.shields.io/gem/v/halbuilder)](https://rubygems.org/gems/halbuilder)
[![Gem](https://img.shields.io/gem/dt/halbuilder)](https://rubygems.org/gems/halbuilder)
![RSpec](https://github.com/PRX/halbuilder/workflows/RSpec/badge.svg)
![Standard](https://github.com/PRX/halbuilder/workflows/Standard/badge.svg)

[Hypertext Application Language](https://en.wikipedia.org/wiki/Hypertext_Application_Language) (HAL)
specific extensions for [Jbuilder](https://github.com/rails/jbuilder).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add halbuilder

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install halbuilder

## Configuration

To customize Halbuilder, create an initializer in your Rails app at `config/initializers/halbuilder.rb`.
Or if not using Rails, you can really configure this gem from anywhere:

```ruby
# config/initializers/halbuilder.rb

Halbuilder.configure do |config|
  config.key_format = :camelize_lower
end
```

Available configurations are:

- `key_format` (default `:camelize_lower`) - the key format used for [Jbuilder formatting keys](https://github.com/rails/jbuilder#formatting-keys)
  - This gem always formats nested keys
  - Allowed values are: `nil` `:underscore` `:dasherize` `:camelize_lower` `:camelize_upper`
- `link_namespace` (default `nil`) - allow namespacing links in a way that breaks `key_format`
  - Can be any alphanumeric string
  - E.g. `"hello"` would cause `json.hello_world "val"` to generate `{"hello:world":"val"}`.
- `link_format` (default `:dasherize`) - format namespaced links differently from `key_format`
  - Only applies if you set a non-nil `link_namespace`
  - Same allowed values as `key_format`
  - E.g. `:dasherize` would cause `json.hello_world_there "val"` to generate `{"hello:world-there":"val"}`

## Usage

This library strives to be low-to-moderately opinionated about how you format your
Jbuilder views. And there will always be many ways to build the same output. But - here are some general patterns for creating HAL JSON APIs.

### Links

The HAL `_links` object can be generated from anywhere within your `*.json.jbuilder` template,
and given either a plain string href or yield a block object:

```ruby
# just a string href
json.hal_link! "hello:one", "/api/v1/hello-one"

# or a block
json.hal_link! 'second' do
  json.href "/api/v1/second"
  json.title "my title"
end

# or manually add a link
json._links do
  json.third_link do
    json.href "/api/v1/thr33"
  end
end
```

```json
{
  "_links": {
    "hello:one": {
      "href": "/api/v1/hello-one"
    },
    "second": {
      "href": "/api/v1/second",
      "title": "my title"
    },
    "thirdLink": {
      "href": "/api/v1/thr33"
    }
  }
}
```

### Embeds

One convention for speeding up HAL APIs is to embed linked resources into the same documents.
For this, we use the `_embedded` top level key, followed by the same `rel` as the link, and
the object or array of objects (or null) you would get back had you followed the link.

```ruby
json.hal_embed! "hello:one" do
  json.id 1234
  json.title "Some Resource"
end

json.hal_embed! "hello:two", 1..3 do |num|
  json.id num
  json.title "Thing #{num}"
end
```

```json
{
  "_embedded": {
    "hello:one": {
      "id": 1234,
      "title": "Some Resource"
    },
    "hello:two": [
      {
        "id": 1,
        "title": "Thing 1"
      },
      {
        "id": 2,
        "title": "Thing 2"
      },
      {
        "id": 3,
        "title": "Thing 3"
      }
    ]
  }
}
```

Note that after the name of the `rel`, you can optionally pass a collection to iterate
over. You can also pass a lambda, just-in-time returning either an object or collection
to render:

```ruby
json.hal_embed! "hello:one", -> { {id: 1234, title: "Some Resource"} } do |obj|
  json.id obj[:id]
  json.title obj[:title]
end

json.hal_embed! "hello:two", -> { 1..3 } do |num|
  json.id num
  json.title "Thing #{num}"
end
```

This works in conjunction with the `?zoom=` query parameter. By passing `zoom: true` to
a `hal_embed!` we indicate that by default, we want to render this collection. Or passing
`zoom: false` indicates not to render it.

```ruby
# GET /api/v1/resource

json.hal_embed! "hello:one", zoom: false do
  title "This will not render"
end

json.hal_embed! "hello:two", zoom: true do
  title "This WILL render"
end
```

Passing `?zoom=1` or `?zoom=0` will result in _ALL_ `hal_embed!`s in the view being
rendered or not rendered, regardless of their defaults.

Passing `?zoom=hello:one,hello:two` will result in just those 2 rels being rendered,
but any other `hal_embed!` with a `zoom:` will not be. This can be used in conjunction
with lambdas/blocks to only load data needed for the requested zoom level:

```ruby
# GET /api/v1/resource?zoom=hello:one,hello:two

json.hal_embed! "hello:one", zoom: false do
  # this code will run and render
  title some_expensive_db.get_title
end

json.hal_embed! "hello:two", -> { some_expensive_db.fetch_two }, zoom: true do |thing|
  # this code will also run and render
  title thing.title
end

json.hal_embed! "hello:three", -> { some_expensive_db.fetch_three }, zoom: true do |thing|
  # this code will NOT run the expensive db operation, OR render
  title thing.title
end

json.hal_embed! "hello:four", zoom: true do
  # this code will not run or render
  title some_expensive_db.get_title
end
```

### Pagination

It's often useful to parse query params and render `_links` to different collection pages,
using the gem [Kaminari](https://github.com/kaminari/kaminari). After paging the collection in
your controller, just call `hal_paginate!` on it:

```ruby
# GET /api/v1/things?foo=bar&page=3

json.hal_paginate! @things
```

```json
{
  "count": 10,
  "total": 999,
  "_links": {
    "first": {
      "href": "/api/v1/accounts?foo=bar"
    },
    "prev": {
      "href": "/api/v1/accounts?foo=bar&page=2"
    },
    "next": {
      "href": "/api/v1/accounts?foo=bar&page=4"
    },
    "last": {
      "href": "/api/v1/accounts?foo=bar&page=100"
    }
  }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Before commiting any code, run `bundle exec standardrb` and/or `bundle exec standardrb --fix` to make sure your changes are compliant with the [Standard](https://github.com/testdouble/standard) style guide.

When you're ready to push changes, open a pull request against the `main branch` of the repo.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PRX/halbuilder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/PRX/halbuilder/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Halbuilder project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/PRX/halbuilder/blob/master/CODE_OF_CONDUCT.md).
