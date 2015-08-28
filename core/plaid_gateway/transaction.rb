require "forwardable"
require "date"

module PlaidGateway
  class Transaction
    def initialize(transaction, account)
      @transaction = transaction
      @account     = account
    end

    attr_reader :account
    attr_accessor :company # so that we can later fill this with company data

    extend Forwardable
    delegate [:id, :name, :amount, :pending] => :@transaction

    def category
      @transaction.category.first
    end

    def date
      Date.parse(@transaction.date)
    end

    def ==(other)
      other.is_a?(Transaction) && self.id == other.id
    end
  end
end
