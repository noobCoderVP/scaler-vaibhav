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
