require "./core/banking"
require "./config/vcr"

module CachedBanking
  def self.method_missing(name, *args, &block)
    VCR.use_cassette("interactions") do
      Banking.send(name, *args, &block)
    end
  end
end
