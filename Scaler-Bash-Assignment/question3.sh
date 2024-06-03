#!/bin/bash

# Check if a service name is provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <service_name>"
  exit 1
fi

SERVICE_NAME=$1

# Check if the service is active and running
if systemctl is-active --quiet "$SERVICE_NAME"; then
  echo "The service '$SERVICE_NAME' is running."
else
  echo "The service '$SERVICE_NAME' is not running."
fi
