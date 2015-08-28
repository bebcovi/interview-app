module ClearbitGateway
  module Configuration
    def configure
      yield self
    end

    def api_key
      Clearbit.key
    end

    def api_key=(value)
      Clearbit.key = value
    end
  end
end
