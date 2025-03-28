#!/bin/bash

DICT="/usr/share/dict/words"

echo "Podaj tekst do sprawdzenia:"
read -r INPUT

for WORD in $INPUT; do
    CLEANED=$(echo "$WORD" | tr -d '[:punct:]')

    if grep -qiw "$CLEANED" "$DICT"; then
        echo -ne "$WORD "
    else
        echo -ne "\e[31m$WORD\e[0m "
    fi
done

echo
