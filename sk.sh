#!/bin/bash

LICZ=1
while read WIERSZ; do
	echo "$LICZ. $WIERSZ"
	LICZ=$((LICZ+1))
done < plik.txt
echo "RAZEM: $LICZ"
