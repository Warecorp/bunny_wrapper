module BunnyWrapper
  module Publisher
    class << self

      def publish_message(payload, routing_key)
        connection = BunnyWrapper::Connection.establish_connection

        ex = BunnyWrapper::Connection.create_topic_exchange(connection)
        ex.publish(payload, routing_key: routing_key)

        connection.close
      end

    end
  end
end
