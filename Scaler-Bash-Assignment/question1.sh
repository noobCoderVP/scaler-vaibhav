#!/bin/bash

# Check if a file path is provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <path_to_log_file>"
  exit 1
fi

LOG_FILE=$1

# Check if the log file exists and is readable
if [ ! -f "$LOG_FILE" ] || [ ! -r "$LOG_FILE" ]; then
  echo "Error: Log file does not exist or is not readable"
  exit 1
fi

# Extract and count total number of requests
total_requests=$(wc -l < "$LOG_FILE")

# Extract and count the number of successful requests (status codes 200-299)
successful_requests=$(grep -E 'HTTP/1.[01]" 2[0-9][0-9]' "$LOG_FILE" | wc -l)

# Calculate percentage of successful requests
if [ $total_requests -eq 0 ]; then
  percentage_success=0
else
  percentage_success=$(echo "scale=2; ($successful_requests / $total_requests) * 100" | bc)
fi

# Find the most active user (IP address with the most requests)
most_active_user=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

# Output the results
echo "Total Requests Count: $total_requests"
echo "Percentage of Successful Requests: $percentage_success%"
echo "Most Active User: $most_active_user"
