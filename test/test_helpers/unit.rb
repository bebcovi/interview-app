require "minitest/hooks/test"
require "./test/test_helpers/concurrency"
require "./test/test_helpers/interactions"
require "./test/test_helpers/mocking"

module TestHelpers
  module Unit
    def self.included(klass)
      klass.include Minitest::Hooks
      klass.include TestHelpers::Concurrency
      klass.include TestHelpers::Interactions
      klass.include TestHelpers::Mocking
    end

    def plaid_test_user
      {
        username:     "plaid_test",
        password:     "plaid_good",
        public_token: "357f78289954f350a36b0a0283f40c713e4134ea9c27182046f521b4a64ddfb7327d6f846af8acfa10ab06bbc8a26cb9c9e2d758f90f3bde1a213520bda62c28",
        access_token: "test_bofa",
      }
    end
  end
end
