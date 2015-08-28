require "./test/integration"
require "pry"

class AppTest < IntegrationTest
  def test_retrieving_transactions
    get "/", public_token: plaid_test_user[:public_token]
  end
end
