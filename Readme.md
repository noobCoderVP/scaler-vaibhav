# Scaler Bash Assignment

## Question 1: Log file analysis

### Objective

Write a Bash script that analyzes a server log file and extracts useful statistics and information,demonstrating your ability to manipulate file data and effectively utilize Bash commands.

### Requirements

**Script Inputs**:  The script should take one command line argument: the path to a log file. Ensure that the script checks if the log file exists and is readable. If not, it should print an error message and exit with a status code 1.

### Features to implement
1. Total request count
2. Percentage of successful requests
3. IP address of the user who made the most number of requests

### Solution


### Code
```bash
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

```

<hr>

## Question 2: Extract and count file types

### Objective

Write a script that counts and lists how many files of each type are present in a given directory.

### Features to implement

1. Traverse a specified directory recursively.
2. Identify file types based on file extensions.
3. Count and list the number of files for each file type.

### Output format

Display a sorted list of file types along with their counts.

### Solution

### Code
```bash
#!/bin/bash

# Check if a directory path is provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <path_to_directory>"
  exit 1
fi

DIR_PATH=$1

# Check if the provided path is a directory and is readable
if [ ! -d "$DIR_PATH" ] || [ ! -r "$DIR_PATH" ]; then
  echo "Error: Directory does not exist or is not readable"
  exit 1
fi

# Initialize an associative array to store the counts of each file type
declare -A file_types

# Traverse the directory recursively and count file types
while IFS= read -r -d '' file; do
  extension="${file##*.}"
  # Check if the file has an extension
  if [[ "$file" == *.* && "$file" != "$extension" ]]; then
    ((file_types["$extension"]++))
  else
    ((file_types["no_extension"]++))
  fi
done < <(find "$DIR_PATH" -type f -print0)

# Print the sorted list of file types along with their counts
for ext in "${!file_types[@]}"; do
  echo "$ext: ${file_types[$ext]}"
done | sort

```
<hr>

## Question 3: Check service status

### Objective

Develop a script that checks if a specific system service (like Apache or SSH) is running and reports its status.

### Features to implement

1. Accept the service name as a command line argument.
2. Use system commands to check if the service is active and running.
3. Output the current status of the service.


### Output format

Clearly state whether the specified service is running or not

### Solution

### Code

```bash
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
```
<hr>
