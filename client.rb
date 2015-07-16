#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

def get_timestamp
  "#{Time.now.strftime('%H:%M:%S')}"
end

conn = Bunny.new
conn.start

queue_name = ENV['RABBITMQ_QUEUE'] || 'default_queue'

args = {}
args['x-message-ttl'] = 5000

ch = conn.create_channel
q  = ch.queue(
  queue_name,
  :arguments   => args,
  :auto_delete => false,
  :exclusive   => false,
  :durable     => true
)

puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"

begin
  q.subscribe(:block => true, :manual_ack => true) do |delivery_info, properties, body|
    puts "[#{get_timestamp}] [ruby client] Received #{body}"

    # Acknowledge that the message has been
    # processed. This prevents:
    # - flooding the client with messages
    # - losing messages if the client dies
    ch.ack(delivery_info.delivery_tag)
  end
rescue

ensure
  conn.close
end
