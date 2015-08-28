require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures"
  config.hook_into :webmock
  config.default_cassette_options = {
    record: :none, # Only replay existing cassettes
    match_requests_on: [:method, ->(request1, request2) do
      uri1 = request1.uri.sub('api', 'tartan')
      uri2 = request2.uri.sub('api', 'tartan')
      request1.method == request2.method && uri1 == uri2
    end]
  }
  config.allow_http_connections_when_no_cassette = true
end
