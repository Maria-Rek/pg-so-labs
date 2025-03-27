#!/bin/bash

# Ścieżka do słownika
DICT="/usr/share/dict/words"

# Wczytaj dane od użytkownika
echo "Podaj tekst do sprawdzenia:"
read -r INPUT

# Przetwarzaj słowa i koloruj błędne na czerwono
for WORD in $INPUT; do
    CLEANED=$(echo "$WORD" | tr -d '[:punct:]')

    if grep -qiw "$CLEANED" "$DICT"; then
        echo -ne "$WORD "
    else
        echo -ne "\e[31m$WORD\e[0m "
    fi
done

# Nowa linia na koniec
echo

#czat, koloruje błędne słowa w pełnym tekście
