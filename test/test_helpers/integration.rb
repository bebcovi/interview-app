require "./test/test_helpers/unit"
require "./test/test_helpers/http"

module TestHelpers
  module Integration
    def self.included(klass)
      klass.include TestHelpers::Unit
      klass.include TestHelpers::Http
    end
  end
end
