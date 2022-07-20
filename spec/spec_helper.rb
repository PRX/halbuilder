# frozen_string_literal: true

require "pry"
require "halbuilder"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    Halbuilder.reset!
  end
end

# cannot use JbuilderTemplate directly - so fake the @context
class Fakebuilder < Jbuilder
  def initialize(context)
    @context = context
    super({})
  end
end
