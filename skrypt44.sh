#!/bin/bash

echo "Część 1"

while read -r line; do
    if [[ "$line" =~ ^[a-z]+(\.[a-z]+)*@[a-z]+(\.[a-z]+)*\.[a-z]{2,}$ ]]; then
        echo "$line"
    fi
done < mail.txt

echo -e "\nCzęść 2"

curl -s "https://raw.githubusercontent.com/bnokoro/Data-Science/refs/heads/master/countries%20of%20the%20world.csv" | \
awk -F',' '$6 ~ /^[ ]*EUROPE[ ]*$/' | \
awk -F',' '{
    gsub(/^[ \t]+|[ \t]+$/, "", $1);  # Country
    gsub(/^[ \t]+|[ \t]+$/, "", $3);  # Population
    gsub(/^[ \t]+|[ \t]+$/, "", $4);  # Area
    printf "  { \"country\": \"%s\", \"population\": %d, \"area\": %d },\n", $1, $3, $4
}' | sed '$s/,$//' | \
awk 'BEGIN { print "[" } { print } END { print "]" }'
