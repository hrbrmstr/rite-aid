#!/bin/bash

# dunno if Rite-Aid web stuff has rate limits and don't care.
# i don't need this info quickly so be nice and wait 5 seconds
# after each request.
#
# cld have done this in R but this is a file i have handy

input_file="input-urls.txt"
output_dir="output"

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

# Read the URLs from the input file
while IFS= read -r url; do
  # Generate an output file name based on the URL
  output_file="${output_dir}/$(basename "${url}").html"

  # Curl the URL and save the content to the output file
  curl -s -o "${output_file}" "${url}"

  # Wait for 5 seconds before processing the next URL
  sleep 5
done < "${input_file}"