#!/usr/bin/bash
# Install dependencies for this example.
# Assumes an OS X environment

echo "Installing RabbitMQ"
brew install rabbitmq

echo "Installing ruby deps"
bundle install

echo "Installing go deps"
go get github.com/streadway/amqp

echo "Installing python deps"
sudo pip install puka
