#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

def get_timestamp
  "#{Time.now.strftime('%H:%M:%S')}"
end

conn = Bunny.new
conn.start

queue_name = ENV['RABBITMQ_QUEUE'] || 'default_queue'

ch = conn.create_channel

# Messages only live for 5 seconds. This
# can be configured as an installation policy,
# check https://www.rabbitmq.com/ttl.html
args = {}
args['x-message-ttl'] = 5000

q = ch.queue(
  queue_name,
  :arguments   => args,
  :auto_delete => false,  # The queue won't be deleted when there are no more consumers.
  :exclusive   => false,  # Exclusive queues may only be accessed by the current
                          # connection, and are deleted when that connection closes.
  :durable     => true    # The queue doesn't die if RabbitMQ restarts
)

seq = 0

begin
  while true
    msg = "#{seq}"
    ch.default_exchange.publish(msg,
                                :routing_key => q.name,
                                :persistent  => true) # Save the message to disk
    puts "[#{get_timestamp}] [server] Sent '#{msg}'"
    seq += 1

    sleep 1
  end
rescue
  puts "Ending server"
ensure
  puts "Closing connection"
  conn.close
end
