# Create connection
conn = Bunny.new
conn.start

# Create channel and queue
ch = conn.create_channel
q = ch.queue(queue_name)

seq = 0
while true
  msg = "#{seq}"

  # Publish
  ch.default_exchange.publish(msg, :routing_key => q.name)

  puts "[#{get_timestamp}] [server] Sent '#{msg}'"
  seq += 1
  sleep 1
end
