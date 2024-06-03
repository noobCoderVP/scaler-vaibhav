#!/bin/bash

# this file contains the solution to problem using the grep commans

# Check if a service name is provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <service_name>"
  exit 1
fi

SERVICE_NAME=$1

# Use systemctl to check the status and grep to filter for the active status
service_status=$(systemctl status "$SERVICE_NAME" | grep -E 'Active:' | awk '{print $2}')

# Check if the service status is "active"
if [ "$service_status" == "active" ]; then
  echo "The service '$SERVICE_NAME' is running."
else
  echo "The service '$SERVICE_NAME' is not running."
fi
