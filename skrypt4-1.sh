#!/bin/bash

while read -r line; do
    if [[ "$line" =~ ^[a-z]+(\.[a-z]+)*@[a-z]+(\.[a-z]+)*\.[a-z]{2,}$ ]]; then
        echo "$line"
    fi
done < mail.txt
