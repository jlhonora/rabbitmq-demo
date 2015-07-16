#!/bin/bash

echo "Starting ruby server"
ruby server.rb &

echo "Starting ruby client"
ruby client.rb &

echo "Starting go client"
go build -o go-client client.go && ./go-client &

echo "Starting python client"
python client.py &
