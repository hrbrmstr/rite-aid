#!/bin/bash

# dunno if Rite-Aid web stuff has rate limits and don't care.
# i don't need this info quickly so be nice and wait 5 seconds
# after each request.
#
# cld have done this in R but this is a file i have handy

input_file="input-urls.txt"
output_dir="output"

slugify() {
  local input="$1"
  local slug

  # Transliterate everything to ASCII
  slug=$(iconv -f utf8 -t ascii//TRANSLIT <<< "$input")

  # Strip out apostrophes
  slug=${slug//\'/}

  # Anything that's not a letter or number to a dash
  slug=$(sed 's/[^a-zA-Z0-9]/-/g' <<< "$slug")

  # Strip leading & trailing dashes
  slug=$(sed 's/^-//' <<< "$slug")
  slug=$(sed 's/-$//' <<< "$slug")

  # Everything to lowercase
  slug=$(tr '[:upper:]' '[:lower:]' <<< "$slug")

  echo "$slug"
}

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

# Read the URLs from the input file
while IFS= read -r url; do

  # Generate an output file name based on the URL
  output_slug="${output_dir}/$(slugify ${url})"

  echo -n "."
  if [ -f "${output_slug}" ]; then 
    continue
  fi

  # Curl the URL and save the content to the output file
  curl -s -o "${output_slug}" "${url}"

  # Wait for 5 seconds before processing the next URL
  sleep 5
done < "${input_file}"