require "./test/setup"
require "./test/test_helpers/integration"

class IntegrationTest < Minitest::Test
  def self.inherited(klass)
    super
    klass.include TestHelpers::Integration
  end
end
