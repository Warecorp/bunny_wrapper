module BunnyWrapper
  class Connection
    class << self

      def establish_connection
        conn = Bunny.new(Configuration.config.symbolize_keys)
        conn.start

        return conn
      end

      def create_topic_exchange(connection)
        exchange = connection.channel.topic(Rails.env, durable: true)
        return exchange
      end

      def bind_exchange_to_queue(queue_name, routing_key, prefetch_count = 1)
        connection = establish_connection

        channel = connection.create_channel
        channel.prefetch(prefetch_count)

        exchange = create_topic_exchange(connection)
        queue    = channel.queue(queue_name, durable: true)
        queue.bind(exchange, routing_key: routing_key)

        return [connection, channel, queue]
      end

    end
  end
end
