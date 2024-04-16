#!/bin/bash

# Custom Tag Names
DOCKER_REPO="abdulmkhan325"
TAG_NAME=$1

# Run Docker build
npm run docker-build
#docker build -t $DOCKER_REPO/react-todo-app:$TAG_NAME .
 
# Run Docker container and capture the output
npm run docker-run &

# Wait for the server to start
sleep 5

# Check if the server is up and running
http_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)

echo $http_status

if [ "$http_status" -eq 200 ]; then
  echo "Server is running, HTTP status code: $http_status"
else
  echo "Error: Server is not running or responded with status code: $http_status"
  exit 1
fi
