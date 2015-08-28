require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures"
  config.hook_into :webmock
  config.default_cassette_options = {record: :new_episodes}
  config.before_record do |interaction|
    # The response bodies are returned as ASCII-8BIT, but Psych, Ruby's YAML
    # encoder, converts strings which are ASCII-8BIT encoded and contain UTF-8
    # characters into binary format, in order to preserve bytes. We want our
    # cassettes readable, so we ensure that the body gets dumped as it is.
    interaction.response.body.force_encoding("UTF-8")
  end
end

module TestHelpers
  module Interactions
    def around
      VCR.use_cassette("interactions") { super }
    end
  end
end
