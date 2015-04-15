module BunnyWrapper
  class Configuration

    DEFAULTS = {
      vhost: '/',
      host: 'localhost',
      port: 5672,
      user: 'guest',
      pass: 'guest'
    }.freeze

    def self.merge!(hash)
      @config = DEFAULTS.dup
      @config.merge!(hash)
    end

    def self.config
      @config
    end

  end
end
