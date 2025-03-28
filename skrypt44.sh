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
    # Wyciągnij region i usuń spacje
    region = $2
    gsub(/^ +| +$/, "", region)

    # Jeśli region zawiera EUROPE (np. EASTERN EUROPE, WESTERN EUROPE itd.)
    if (region ~ /EUROPE/) {
        gsub(/^ +| +$/, "", $1)  # Country
        gsub(/^ +| +$/, "", $3)  # Population
        gsub(/^ +| +$/, "", $4)  # Area

        # usuń przecinki dziesiętne i zamień na kropki (jak trzeba)
        pop = $3; gsub(",", ".", pop)
        area = $4; gsub(",", ".", area)

        # tylko jeśli to są liczby
        if (pop ~ /^[0-9.]+$/ && area ~ /^[0-9.]+$/) {
            printf "  { \"country\": \"%s\", \"population\": %d, \"area\": %d },\n", $1, pop, area
        }
    }
}' | sed '$s/,$//' | awk 'BEGIN { print "[" } { print } END { print "]" }'
