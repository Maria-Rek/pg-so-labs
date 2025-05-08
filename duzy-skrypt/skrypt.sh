#!/bin/bash
# Author           : Maria Rek (s203174@student.pg.edu.pl)
# Created On       : 2025-04-20
# Last Modified By : Maria Rek (s203174@student.pg.edu.pl)
# Last Modified On : 2025-05-07
# Version          : 1.0
#
# Description      :
# Generator i menedżer haseł z interfejsem graficznym Zenity
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact the Free Software Foundation for a copy)

. ./skrypt.rc

if [[ "$#" -gt 0 ]]; then
  while getopts "hvgsazo" opt; do
    case $opt in
      h) pokaz_pomoc ;;
      v) pokaz_wersje ;;
      g) generuj_haslo ;;
      s) pokaz_hasla ;;
      a) dodaj_recznie ;;
      z) zapisz_szyfrowane ;;
      o) odczytaj_szyfrowane ;;
      *) echo "Nieprawidłowa opcja." ;;
    esac
  done
  exit 0
fi

wybor=$(zenity --list --title="Menedżer Haseł" --column="Akcja" \
  "Dodaj ręcznie" "Przeglądaj zapisane hasła" \
  "Zapisz do zaszyfrowanego pliku" "Odczytaj z zaszyfrowanego pliku" \
  --height=300 --width=400)

case "$wybor" in
  "Dodaj ręcznie") dodaj_recznie ;;
  "Przeglądaj zapisane hasła") pokaz_hasla ;;
  "Zapisz do zaszyfrowanego pliku") zapisz_szyfrowane ;;
  "Odczytaj z zaszyfrowanego pliku") odczytaj_szyfrowane ;;
  *) exit 0 ;;
esac
