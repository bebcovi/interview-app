require "dotenv"
Dotenv.load!

require "./test/setup"
require "./test/test_helpers/unit"

class UnitTest < Minitest::Test
  def self.inherited(klass)
    super
    klass.include TestHelpers::Unit
  end
end
