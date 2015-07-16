#!/bin/bash

kill -TERM `ps aux | grep 'ruby client'   | awk -F ' ' '{print $2}'`
kill -TERM `ps aux | grep 'ruby server'   | awk -F ' ' '{print $2}'`
kill -TERM `ps aux | grep 'python client' | awk -F ' ' '{print $2}'`
kill -TERM `ps aux | grep 'go-client'     | awk -F ' ' '{print $2}'`
