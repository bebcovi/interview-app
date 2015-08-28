require "rack/test"
require "./app"

module TestHelpers
  module Http
    include Rack::Test::Methods

    def app
      App
    end

    alias response last_response
  end
end
