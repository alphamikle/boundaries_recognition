#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 path/to/directory"
  exit 1
fi

DIRECTORY="$1"

if [ ! -d "$DIRECTORY" ]; then
  echo "Error: Directory $DIRECTORY does not exist."
  exit 1
fi

resize_image() {
  local file="$1"
  local dimensions
  dimensions=$(identify -format "%wx%h" "$file")
  convert "$file" -resize 1200x900 "$file"
  echo "$file resized"
}

find "$DIRECTORY" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r image; do
  resize_image "$image"
done
