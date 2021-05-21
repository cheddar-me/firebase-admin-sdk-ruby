# frozen_string_literal: true

require "rspec"
require "googleauth"
require "webmock/rspec"
require "firebase-admin-sdk"
require "fakefs/spec_helpers"
require "climate_control"
require "active_support/testing/time_helpers"
require "active_support/core_ext/numeric/time"

require "unit/helpers/auth_helper"
require "unit/helpers/jwt_helper"

WebMock.disallow_net_connect!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.expose_dsl_globally = true
end

def fixture(file_name)
  fixture_path = File.expand_path("fixtures", __dir__)
  File.new("#{fixture_path}/#{file_name}")
end
