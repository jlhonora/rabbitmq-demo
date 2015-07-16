#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

def get_timestamp
  "#{Time.now.strftime('%H:%M:%S')}"
end

conn = Bunny.new
conn.start

queue_name = ENV['RABBIT_QUEUE'] || 'default_queue'

ch   = conn.create_channel
q    = ch.queue(queue_name)

puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts "[#{get_timestamp}] [ruby client] Received #{body}"
  end
rescue

ensure
  conn.close
end
