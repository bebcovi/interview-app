require "plaid"
require "./core/plaid_gateway/configuration"
require "./core/plaid_gateway/user"

module PlaidGateway
  extend self
  extend Configuration

  def find_user(public_token)
    access_token = get_access_token(public_token)
    user = get_user(access_token)
    User.new(user)
  end

  def get_access_token(public_token)
    client.exchange_token(public_token).access_token
  end

  def get_user(access_token)
    client.transactions(access_token)
  end

  private

  def client
    Plaid
  end
end

PlaidGateway.configure do |config|
  config.client_id   = ENV.fetch("PLAID_CLIENT_ID")
  config.secret      = ENV.fetch("PLAID_SECRET")
  config.environment = ENV.fetch("PLAID_ENVIRONMENT")
  config.public_key  = ENV.fetch("PLAID_PUBLIC_KEY")
end
