#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

def get_timestamp
  "#{Time.now.strftime('%H:%M:%S')}"
end

conn = Bunny.new(hostname: "amqp://guest:guest@localhost:5672/")
conn.start

queue_name = ENV['RABBITMQ_QUEUE'] || 'default_queue'

ch   = conn.create_channel
q    = ch.queue(queue_name)

seq = 0

begin
  while true
    msg = "#{seq}"
    ch.default_exchange.publish(msg, :routing_key => q.name)
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
