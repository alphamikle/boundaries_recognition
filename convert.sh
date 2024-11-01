#!/bin/bash

new_size="300x400"

cd ./example/assets/cards || exit 1

if [ -d "$new_size" ]; then
    rm -rf "$new_size"
fi

mkdir "$new_size"

for file in *.heic *.HEIC; do
    if [[ -f "$file" ]]; then
        filename="${file%.*}"
        output_file="${new_size}/${filename}.jpg"

        magick convert "$file" -resize "$new_size" "$output_file"

        echo "Converted $file -> $output_file"
    fi
done
