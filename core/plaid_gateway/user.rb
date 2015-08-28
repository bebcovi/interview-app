require "./core/plaid_gateway/account"

module PlaidGateway
  class User
    def initialize(user)
      @accounts = user.accounts.map do |account|
        transactions = user.transactions.select { |t| t.account == account.id }
        Account.new(account, transactions)
      end
    end

    attr_reader :accounts

    def transactions
      @transactions ||= accounts.flat_map(&:transactions)
    end
  end
end
