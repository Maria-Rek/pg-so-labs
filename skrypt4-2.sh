#!/bin/bash

curl -s "https://raw.githubusercontent.com/bnokoro/Data-Science/refs/heads/master/countries%20of%20the%20world.csv" | \
grep "EUROPE" | \
awk -F',' '{
    gsub(/^[ \t]+|[ \t]+$/, "", $1);  # Country
    gsub(/^[ \t]+|[ \t]+$/, "", $3);  # Population
    gsub(/^[ \t]+|[ \t]+$/, "", $4);  # Area
    printf "  { \"country\": \"%s\", \"population\": %d, \"area\": %d },\n", $1, $3, $4
}' | sed '$s/,$//' | \
awk 'BEGIN { print "[" } { print } END { print "]" }'
