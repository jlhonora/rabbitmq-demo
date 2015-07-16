package main

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/streadway/amqp"
)

func failOnError(err error, msg string) {
	if err != nil {
		log.Fatalf("%s: %s", msg, err)
		panic(fmt.Sprintf("%s: %s", msg, err))
	}
}

func getQueueName() string {
	queue_name := os.Getenv("RABBITMQ_QUEUE")
	if queue_name == "" {
		queue_name = "default_queue"
	}
	return queue_name
}

func getTimestamp() string {
	t := time.Now()
	return t.Format("15:04:05")
}

func main() {
	conn, err := amqp.Dial("amqp://guest:guest@localhost:5672/")
	failOnError(err, "Failed to connect to RabbitMQ")
	defer conn.Close()

	ch, err := conn.Channel()
	failOnError(err, "Failed to open a channel")
	defer ch.Close()

	queue_name := getQueueName()
	q, err := ch.QueueDeclare(
		queue_name, // name
		false,      // durable
		false,      // delete when usused
		false,      // exclusive
		false,      // no-wait
		nil,        // arguments
	)
	failOnError(err, "Failed to declare a queue")

	msgs, err := ch.Consume(
		q.Name, // queue
		"",     // consumer
		true,   // auto-ack
		false,  // exclusive
		false,  // no-local
		false,  // no-wait
		nil,    // args
	)
	failOnError(err, "Failed to register a consumer")

	forever := make(chan bool)

	go func() {
		for d := range msgs {
			fmt.Printf("%s [go client] Received %s\n", getTimestamp(), d.Body)
		}
	}()

	log.Printf(" [*] Waiting for messages in %s. To exit press CTRL+C", queue_name)
	<-forever
}
