#!/bin/bash

echo "Część 1"

while read -r line; do
    if [[ "$line" =~ ^[a-z]+(\.[a-z]+)*@[a-z]+(\.[a-z]+)*\.[a-z]{2,}$ ]]; then
        echo "$line"
    fi
done < mail.txt

echo -e "\nCzęść 2"

curl -s "https://raw.githubusercontent.com/bnokoro/Data-Science/refs/heads/master/countries%20of%20the%20world.csv" | \
awk -F',' 'NR > 1 {
    region = $2
    gsub(/^[ \t]+|[ \t]+$/, "", region)
    if (region ~ /EUROPE/) {
        country = $1
        population = $3
        area = $4

        gsub(/^[ \t]+|[ \t]+$/, "", country)
        gsub(/^[ \t]+|[ \t]+$/, "", population)
        gsub(/^[ \t]+|[ \t]+$/, "", area)

        # drukujemy tylko jeśli population i area to liczby całkowite
        if (population ~ /^[0-9]+$/ && area ~ /^[0-9]+$/) {
            printf "  { \"country\": \"%s\", \"population\": %s, \"area\": %s },\n", country, population, area
        }
    }
}' | sed '$s/,$//' | awk 'BEGIN { print "[" } { print } END { print "]" }'
