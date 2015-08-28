module PlaidGateway
  module Configuration
    def configure
      yield self
    end

    def test_mode!
      self.client_id = "test_id"
      self.secret    = "test_secret"
    end

    attr_accessor :public_key

    def environment
      env = Plaid.environment_location.to_s[/tartan|api/]
      env = "production" if env == "api"
      env
    end

    def environment=(value)
      Plaid.environment_location = "https://#{value}.plaid.com/"
    end

    def client_id=(value)
      Plaid.customer_id = value
    end

    def client_id
      Plaid.customer_id
    end

    def secret=(value)
      Plaid.secret = value
    end

    def secret
      Plaid.secret
    end
  end
end
