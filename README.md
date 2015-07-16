A simple [RabbitMQ](https://www.rabbitmq.com/) demo, with consumers (clients) in Ruby, Python and Go.

Setup for OS X:

```
./setup.sh
```

To start:

```
rabbitmq-server
./run.sh
```

To stop:

```
./kill.sh
```

Helpful commands:

```
rabbitmqadmin delete queue name=default_queue
rabbitmqctl list_queues default_queue messages_ready messages_unacknowledged
```
