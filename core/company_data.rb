require "./core/clearbit_gateway"
require "celluloid"

module CompanyData
  extend self
  DOMAIN_REGEXP = /[\w\-]+\.\w+/

  def gather(strings)
    domains = extract_domains(strings)
    fetch(domains)
  end

  private

  def fetch(domains)
    Fetcher.call(domains)
  end

  def extract_domains(strings)
    strings.map { |string| string[DOMAIN_REGEXP] }
  end

  class Fetcher
    include Celluloid

    def self.call(domains)
      pool = self.pool(size: 5)
      futures = domains.map { |domain| pool.future.fetch(domain) }
      futures.map(&:value)
    end

    def fetch(domain)
      ClearbitGateway.find_company(domain) if domain
    end
  end
end
