# Create connection
conn = Bunny.new
conn.start

# Create channel and queue
ch = conn.create_channel
q  = ch.queue(queue_name)

q.subscribe(:block => true) do |delivery_info, properties, body|
  puts "[#{get_timestamp}] [ruby client] Received #{body}"
end
