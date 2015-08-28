require "./core/plaid_gateway"
require "./core/company_data"

module Banking
  extend self

  def find_plaid_user(public_token)
    user = PlaidGateway.find_user(public_token)
    fill_transactions_with_company_data(user)
    user
  end

  private

  def fill_transactions_with_company_data(user)
    transactions = user.transactions
    companies = CompanyData.gather(transactions.map(&:name))

    transactions.zip(companies) do |transaction, company|
      transaction.company = company
    end
  end
end
