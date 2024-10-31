#!/bin/bash

new_size="300x400"

output_dir="small"

cd ./example/assets/cards || exit 1

if [ -d "$output_dir" ]; then
    rm -rf "$output_dir"
fi
mkdir "$output_dir"

counter=1

for file in *.heic *.HEIC; do
    if [[ -f "$file" ]]; then
        output_file="${output_dir}/${new_size}_${counter}.jpg"

        magick convert "$file" -resize "$new_size" "$output_file"

        echo "Converted $file -> $output_file"

        counter=$((counter + 1))
    fi
done
