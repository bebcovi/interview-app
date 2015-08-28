require "./core/plaid_gateway/transaction"
require "./core/plaid_gateway/recurring_transactions"
require "forwardable"

module PlaidGateway
  class Account
    def initialize(account, transactions)
      @account      = account
      @transactions = transactions
        .map { |t| Transaction.new(t, self) }
        .sort { |x, y| y.date <=> x.date } # DESC
    end

    attr_reader :transactions

    extend Forwardable
    delegate [:id, :available_balance, :current_balance] => :@account

    # https://github.com/plaid/plaid-ruby/pull/80
    def name
      @account.meta["name"]
    end

    def ==(other)
      other.is_a?(Account) && self.id == other.id
    end

    def recurring_transactions
      RecurringTransactions.extract(transactions)
    end
  end
end
