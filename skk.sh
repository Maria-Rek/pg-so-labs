#!/bin/bash
LICZ=1
cat plik.txt | while read WIERSZ; do
	echo "$LICZ. $WIERSZ"
	LICZ=$(($LICZ+1))
done
echo "RAZEM: $LICZ"
