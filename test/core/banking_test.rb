require "./test/unit"
require "./core/banking"

class BankingTest < UnitTest
  def test_retreiving_user_from_plaid
    user = Banking.find_plaid_user(plaid_test_user[:public_token])
    assert_instance_of PlaidGateway::User, user
  end

  def test_filling_transactions_with_company_data
    user = Banking.find_plaid_user(plaid_test_user[:public_token])

    assert_equal "GitHub",   user.transactions[0].company.name
    assert_equal "DNSimple", user.transactions[1].company.name
  end
end
