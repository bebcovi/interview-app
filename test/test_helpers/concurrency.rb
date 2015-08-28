module TestHelpers
  module Concurrency
    def before_all
      super
      if defined?(Celluloid)
        Celluloid.logger.level = Logger::WARN
        # Minitest runs tests on #at_exit, but Celluloid also shutdowns on
        # #at_exit, so we need to reboot it for tests.
        Celluloid.boot
      end
    end
  end
end
