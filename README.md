# Halbuilder

[![license](https://img.shields.io/github/license/PRX/halbuilder.svg)](LICENSE)
[![Gem](https://img.shields.io/gem/v/halbuilder)](https://rubygems.org/gems/halbuilder)
[![Gem](https://img.shields.io/gem/dt/halbuilder)](https://rubygems.org/gems/halbuilder)
![Ruby CI](https://github.com/PRX/halbuilder/workflows/Ruby%20CI/badge.svg)

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

### Pagination



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cavis/halbuilder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/cavis/halbuilder/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Halbuilder project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cavis/halbuilder/blob/master/CODE_OF_CONDUCT.md).
