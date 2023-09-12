#!/bin/bash

# Script Summary:
# This script iterates through a directory, creates or updates tar archives
# of subdirectories if needed, and writes them to an LTO tape drive (/dev/st0).
# It keeps track of the number of archives created, the total size of
# the backups, and the duration of the backup process.

# DISCLAIMER: This script is provided as-is and without warranty.
# Use it at your own risk. The script may result in data loss if
# not used properly. Make sure to understand and modify the script
# to suit your specific requirements. The author is not responsible
# for any data loss or damage that may occur as a result of using
# this script.

# Directory to search for subdirectories
search_dir="/path/to/your/directory"

# Define the target device
target_device="/dev/st0"

# Initialize a counter for archives created
archives_created=0

# Initialize a variable to track the total size in bytes
total_size_bytes=0

# Function to check if the tape is empty
check_tape_empty() {
  mt -f "$target_device" rewind   # Rewind the tape
  tape_status=$(mt -f "$target_device" status)
  if [[ $tape_status =~ "file number 0" ]]; then
    return 0  # Tape is empty
  else
    return 1  # Tape is not empty
  fi
}

# Function to count subdirectories in the search directory
count_directories() {
  local dir_count=0
  for dir in "$1"/*; do
    if [ -d "$dir" ]; then
      ((dir_count++))
    fi
  done
  echo "$dir_count"
}

# Calculate the total number of directories to tar
total_dirs=$(count_directories "$search_dir")

# Check if the target device exists
if [ ! -e "$target_device" ]; then
  echo "Error: $target_device does not exist. Make sure the target device is available."
  exit 1
fi

# Check if the target device is writable
if [ ! -w "$target_device" ]; then
  echo "Error: $target_device is not writable. Check permissions."
  exit 1
fi

# Check if the tape is empty
if check_tape_empty; then
  echo "The tape is empty, proceeding with the backup."
else
  echo "Error: The tape is not empty. Existing data found on the tape. Aborting."
  exit 1
fi

# Record the start time
start_time=$(date +%s)

# Initialize a counter for directory progress
dir_count=0

# Iterate through subdirectories in the specified directory
for dir in "$search_dir"/*; do
  if [ -d "$dir" ]; then
    ((dir_count++))
    # Extract the directory name from the path
    dir_name=$(basename "$dir")

    # Check if the archive already exists and if it's older than the source directory
    if [ -e "$target_device/$dir_name.tar" ] && [ "$dir" -nt "$target_device/$dir_name.tar" ]; then
      # Update the existing archive
      tar uvf "$target_device" -C "$search_dir" "$dir_name"
    else
      # Create a new archive
      tar cvf "$target_device" -C "$search_dir" "$dir_name"
      ((archives_created++))
    fi

    # Check if the tar operation was successful
    if [ $? -eq 0 ]; then
      # Calculate the size of the archive in bytes and add it to the total
      archive_size_bytes=$(du -sb "$dir" | cut -f1)
      ((total_size_bytes += archive_size_bytes))
    else
      echo "Error: Failed to backup $dir_name"
      exit 1
    fi

    # Print progress
    echo "Progress: $dir_count of $total_dirs directories processed"
  fi
done

# Record the end time
end_time=$(date +%s)

# Calculate the duration in minutes
duration_minutes=$(( (end_time - start_time) / 60 ))

# Convert the total size to gigabytes
total_size_gb=$(bc <<< "scale=2; $total_size_bytes / (1024 * 1024 * 1024)")

# Print the summary of archives created, total size, and the duration
echo "Archives Created: $archives_created"
echo "Total size archived: ${total_size_gb}GB"
echo "Backup process completed in $duration_minutes minutes"
