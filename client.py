#!/usr/bin/env python

import os
import datetime
import sys
sys.path.append("..")
import puka

def get_queue_name():
    return os.environ.get('RABBITMQ_QUEUE', 'default_queue')

def get_timestamp():
    return datetime.datetime.utcnow().strftime("%H:%M:%S")

# Puka uses IPv6 addresses first, so we can't use localhost
# as address. Check https://github.com/majek/puka/issues/35
client = puka.Client("amqp://guest:guest@127.0.0.1:5672/")

promise = client.connect()
client.wait(promise)

queue_name = get_queue_name()
promise = client.queue_declare(queue=queue_name)
client.wait(promise)

print "  [*] Waiting for messages in %s. Press CTRL+C to quit." % queue_name

consume_promise = client.basic_consume(queue=queue_name, prefetch_count=1)
while True:
    result = client.wait(consume_promise)
    print "%s [python client] Received %r" % (get_timestamp(), result['body'])
    client.basic_ack(result)

promise = client.close()
client.wait(promise)
