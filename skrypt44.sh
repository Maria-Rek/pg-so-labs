echo -e "\nCzęść 2"

curl -s "https://gist.githubusercontent.com/alex4321/0a2da1d87205a6c29f0d4235e9523565/raw/ce9fa5637a670e846a37d9a3d9bf36aea547314d/world-population.csv" | \
awk -F',' 'NR > 1 {
    region = $2
    gsub(/^[ \t]+|[ \t]+$/, "", region)
    if (region ~ /Europe/) {
        country = $1
        population = $3

        gsub(/^[ \t]+|[ \t]+$/, "", country)
        gsub(/^[ \t]+|[ \t]+$/, "", population)

        if (population ~ /^[0-9]+$/) {
            printf "  { \"country\": \"%s\", \"population\": %s },\n", country, population
        }
    }
}' | sed '$s/,$//' | awk 'BEGIN { print "[" } { print } END { print "]" }' > europe.json

echo "Zapisano dane do europe.json"