require "clearbit"
require "./core/clearbit_gateway/configuration"

module ClearbitGateway
  extend self
  extend Configuration

  def find_company(domain)
    Clearbit::Company[domain: domain]
  end
end

ClearbitGateway.configure do |config|
  config.api_key = ENV.fetch("CLEARBIT_API_KEY")
end
