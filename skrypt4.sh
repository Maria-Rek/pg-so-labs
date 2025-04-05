#!/bin/bash

echo "Część 1"

while read -r line; do
    if [[ "$line" =~ ^[a-z]+(\.[a-z]+)*@[a-z]+(\.[a-z]+)*\.[a-z]{2,}$ ]]; then
        echo "$line"
    fi
done < mail.txt

echo -e "\nCzęść 2"

filename='countries.csv'

echo "[" > wynik.json
tail -n +2 "$filename" | while IFS=',' read -r rank cca3 country capital continent population2022 _; do
    if [[ "$continent" == "Europe" ]]; then
        echo " {\"country\":\"$country\",\"population\":\"$population2022\"},">> wynik.json
    fi
done
