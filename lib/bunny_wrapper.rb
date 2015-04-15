require 'bunny_wrapper/version'
require 'bunny_wrapper/publisher/base_worker'
require 'bunny_wrapper/publisher/publisher'
require 'bunny_wrapper/connection'
require 'bunny_wrapper/configuration'
require 'bunny_wrapper/railtie' if defined?(Rails)
require 'bunny_wrapper/consumer'
require 'bunny'

module BunnyWrapper

  Configuration.merge!({})

  class << self

    def configure(opts = {})
      Configuration.merge!(opts)
    end

  end
end
