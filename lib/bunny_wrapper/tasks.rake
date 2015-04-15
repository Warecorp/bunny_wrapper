task :environment

namespace :consumer do

  desc 'Start Consumer'
  task :start_consumer_with_params, [:queue_name, :routing_key] => :environment do |t, args|
    begin
      consumer = BunnyWrapper::Consumer.new(args[:queue_name], args[:routing_key])
      consumer.listen_queue
    rescue Exception => e
      puts e.message unless e.is_a?(Interrupt)
    rescue Interrupt => _
      puts 'Going to shutdown...'
    ensure
      consumer.finish_work if consumer
      puts 'Ended work'
    end
  end

end
