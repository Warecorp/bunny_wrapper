module BunnyWrapper
  module Publisher

    class BaseWorker

      DEFAULT_ROUTING_KEY = 'default.routing'

      class << self

        def inherited(subclass)
          subclass.instance_eval do
            cattr_accessor :_connection_options
          end
        end

        def connection_options(options)
          self._connection_options ||= {}
          self._connection_options[:routing_key] = options.fetch(:routing_key, DEFAULT_ROUTING_KEY)
        end

        def perform_async(*args)
          payload = { worker: self.name, args: args, retries: 0 }.to_json
          routing_key = self._connection_options[:routing_key]
          BunnyWrapper::Publisher.publish_message(payload, routing_key)
        end

        def perform_async_with_custom_route(*args, message_header)
          payload = { worker: self.name, args: args, reltries: 0 }.to_json
          routing_key = self._connection_options[:routing_key] + ".#{message_header}"

          BunnyWrapper::Publisher.publish_message(payload, routing_key)
        end

      end

      def perform(*args)
        raise 'Must be implemented in a subclass'
      end

    end

  end
end
