require 'log4r'
require 'log4r/outputter/fileoutputter'

module BunnyWrapper
  class Consumer
    include Log4r

    RETRIES_COUNT  = 3
    PREFETCH_COUNT = 1

    def initialize(queue_name, *routing_key)
      @queue_name = queue_name
      @routing_keys = routing_key.flatten
      @retries = 0
      initialize_logger
    end

    def initialize_logger
      logger_path = Dir.mkdir("log/consumer") unless File.exists?("log/consumer")
      @logger = Logger.new("#{@queue_name}")
      @logger.add FileOutputter.new(
        @queue_name,
        filename: "#{Rails.root}/log/consumer/queue_#{@queue_name}.log"
      )
      @logger.add Outputter.stdout unless Rails.env.test?
      @logger.info "#{Time.now} | Consumer initialized for queue |#{@queue_name}| and key |#{@routing_keys}|"
      @logger.level = Log4r::DEBUG
    end

    def listen_queue
      @routing_keys.each do |routing_key|
        @conn, @channel, @queue = Connection.bind_exchange_to_queue(@queue_name, routing_key, PREFETCH_COUNT)
      end

      @queue.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
        @logger.info "#{Time.now} [x] Routing key |#{delivery_info.routing_key}| received |#{body}|"
        begin
          handle_message(delivery_info, properties, body)
        rescue Exception => e
          @logger.error "Exception: #{body} | #{e.message}"
        end
      end
    end

    def handle_message(delivery_info, properties, body)
      parsed_body = JSON.parse(body)
      klass = parsed_body["worker"].constantize
      args  = parsed_body["args"]

      begin
        klass.new.perform(*args)
        @channel.ack(delivery_info.delivery_tag)
        @logger.info "#{Time.now} ACCEPTED: #{parsed_body}"
      rescue Exception => e
        @logger.error "Exception: #{parsed_body} | #{e.message}"
        @channel.reject(delivery_info.delivery_tag)
        if parsed_body['retries'] >= RETRIES_COUNT
          @logger.warn "#{Time.now} REJECTED: #{parsed_body}"
        else
          sleep(5)
          requeue(parsed_body, delivery_info.routing_key)
        end
      end
    end

    def requeue(payload, routing_key)
      payload['retries'] += 1
      @logger.warn "#{Time.now} RETRY #{payload}"

      BunnyWrapper::Publisher.publish_message(payload.to_json, routing_key)
    end

    def finish_work
      @channel.close
      @conn.close
    end

  end
end
