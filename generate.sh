#!/bin/bash

# Initialize variables
directory=""
output_file=""

# Function to display usage information
usage() {
  echo "Usage: $0 --dir <directory> --output <output_file>"
  exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --dir)
      directory="$2"
      shift 2
      ;;
    --output)
      output_file="$2"
      shift 2
      ;;
    *)
      echo "Unknown parameter passed: $1"
      usage
      ;;
  esac
done

# Check if both arguments are provided
if [[ -z "$directory" || -z "$output_file" ]]; then
  echo "Error: Both --dir and --output arguments are required."
  usage
fi

# Check if the specified directory exists
if [[ ! -d "$directory" ]]; then
  echo "Error: Directory '$directory' does not exist."
  exit 1
fi

# Get the base name of the directory (e.g., 'assets')
dir_basename=$(basename "$directory")

# Define an array of forbidden substrings
forbidden_strings=(
  ".heic"
  ".DS_Store"
)

# Start generating the Dart code
echo "const List<String> images = [" > "$output_file"

# Find all files recursively in the specified directory
find "$directory" -type f | while read -r file; do
  # Compute the path relative to the specified directory
  relative_path="${file#$directory/}"

  # Build the path starting with the base directory name
  relative_file_path="$dir_basename/$relative_path"

  # Replace backslashes with forward slashes (for Windows compatibility)
  relative_file_path="${relative_file_path//\\//}"

  # Check if the file path contains any forbidden strings
  skip_file=false
  for forbidden in "${forbidden_strings[@]}"; do
    if [[ "$relative_file_path" == *"$forbidden"* ]]; then
      skip_file=true
      break
    fi
  done

  # If the file is not to be skipped, add it to the Dart file
  if [ "$skip_file" = false ]; then
    # Escape single quotes in the path
    escaped_path=$(printf '%s\n' "$relative_file_path" | sed "s/'/\\'/g")

    # Add the file path to the Dart file
    echo "  '$escaped_path'," >> "$output_file"
  fi
done

# Close the Dart list
echo "];" >> "$output_file"

echo "Dart file '$output_file' has been successfully generated with file paths."
