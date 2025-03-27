#!/bin/bash

echo "Podaj tekst do sprawdzenia:"
read input_text

echo "$input_text" | tr ' ' '\n' | tr -d '[:punct:]' | while read word; do
    if ! grep -q "^$word$" /usr/share/dict/words; then
        incorrect_words+="$word "
    fi
done

if [ -z "$incorrect_words" ]; then
    echo "Wszystkie słowa są poprawne."
    exit 0
fi

#Wersja 1: Wyświetlenie tylko niepoprawnych słów
echo "Nieznalezione w słowniku:"
echo "$incorrect_words"

#Wersja 2: Podświetlenie błędnych słów w tekście
highlighted_text="$input_text"
for word in $incorrect_words; do
    highlighted_text=$(echo "$highlighted_text" | sed "s/\b$word\b/\033[1;31m$word\033[0m/g")
done

echo -e "\nTekst z podświetlonymi błędami:"
echo -e "$highlighted_text"
