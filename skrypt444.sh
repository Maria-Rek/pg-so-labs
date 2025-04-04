#!/bin/bash

echo -e "\nCzęść 2 – konwersja CSV do JSON (Europa)"

curl -s "https://gist.githubusercontent.com/alex4321/0a2da1d87205a6c29f0d4235e9523565/raw/ce9fa5637a670e846a37d9a3d9bf36aea547314d/world-population.csv" | \
awk -F',' '
BEGIN {
    OFS = ","
}
NR==1 {
    for (i=1; i<=NF; i++) {
        if ($i ~ /Country\/Territory/) country_idx = i
        if ($i ~ /2022 Population/) pop_idx = i
        if ($i ~ /Continent/) cont_idx = i
    }
    next
}
{
    gsub(/"/, "", $country_idx)
    gsub(/"/, "", $pop_idx)
    gsub(/"/, "", $cont_idx)

    if ($cont_idx == "Europe") {
        printf "  { \"country\": \"%s\", \"population\": %s },\n", $country_idx, $pop_idx
    }
}
' | sed '$s/,$//' | awk 'BEGIN { print "[" } { print } END { print "]" }'