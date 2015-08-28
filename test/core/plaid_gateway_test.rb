require "./test/unit"
require "./core/plaid_gateway"

class PlaidGatewayTest < UnitTest
  def setup
    @user = PlaidGateway.find_user(plaid_test_user[:public_token])
  end

  def test_user
    assert_instance_of PlaidGateway::User, @user
  end

  def test_account
    account = @user.accounts.first

    assert_instance_of String, account.id
    assert_instance_of String, account.name
    assert_kind_of Numeric, account.available_balance
    assert_kind_of Numeric, account.current_balance
  end

  def test_transaction
    account     = @user.accounts.first
    transaction = account.transactions.first

    assert_equal account, transaction.account
    assert_instance_of String, transaction.id
    assert_instance_of String, transaction.name
    assert_instance_of String, transaction.category
    assert_kind_of Numeric, transaction.amount
    assert_instance_of Date, transaction.date
    assert_includes [true, false], transaction.pending
  end
end

class RecurringTransactionsTest < UnitTest
  def test_recognizing
    account = PlaidGateway::Account.new(nil, [
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2015-2-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2015-3-1"),
    ])

    refute_empty account.recurring_transactions
    assert_equal Date.new(2015, 3, 1), account.recurring_transactions.first[0].date
    assert_equal Date.new(2015, 2, 1), account.recurring_transactions.first[1].date
    assert_equal Date.new(2015, 1, 1), account.recurring_transactions.first[2].date
  end

  def test_need_to_have_the_same_name
    account = PlaidGateway::Account.new(nil, [
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-1"),
      double(:transaction, name: "Bar", amount: 30, date: "2015-2-1"),
      double(:transaction, name: "Baz", amount: 30, date: "2015-3-1"),
    ])

    assert_empty account.recurring_transactions
  end

  def test_need_to_have_the_same_amount
    account = PlaidGateway::Account.new(nil, [
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-1"),
      double(:transaction, name: "Foo", amount: 40, date: "2015-2-1"),
      double(:transaction, name: "Foo", amount: 50, date: "2015-3-1"),
    ])

    assert_empty account.recurring_transactions
  end

  def test_need_to_recur_more_than_3_times
    account = PlaidGateway::Account.new(nil, [
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2015-2-1"),
    ])

    assert_empty account.recurring_transactions
  end

  def test_need_to_recur_in_regular_date_intervals
    # Days
    account = PlaidGateway::Account.new(nil, [
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-30"),
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-31"),
      double(:transaction, name: "Foo", amount: 30, date: "2015-2-1"),
    ])
    refute_empty account.recurring_transactions

    # Months
    account = PlaidGateway::Account.new(nil, [
      double(:transaction, name: "Foo", amount: 30, date: "2015-11-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2015-12-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2016-1-1"),
    ])
    refute_empty account.recurring_transactions

    # Years
    account = PlaidGateway::Account.new(nil, [
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2016-1-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2017-1-1"),
    ])
    refute_empty account.recurring_transactions
  end

  def test_irregular_date_intervals
    # Days
    account = PlaidGateway::Account.new(nil, [
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-2"),
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-4"),
    ])
    assert_empty account.recurring_transactions

    # Months
    account = PlaidGateway::Account.new(nil, [
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2015-2-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2015-3-2"),
    ])
    assert_empty account.recurring_transactions

    # Years
    account = PlaidGateway::Account.new(nil, [
      double(:transaction, name: "Foo", amount: 30, date: "2015-1-1"),
      double(:transaction, name: "Foo", amount: 30, date: "2016-1-2"),
      double(:transaction, name: "Foo", amount: 30, date: "2017-2-1"),
    ])
    assert_empty account.recurring_transactions
  end
end
