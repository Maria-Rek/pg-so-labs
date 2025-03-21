#!/bin/bash

file_name=""
directory=""
options1=""
options2=""
content=""

while true; do
    clear
    echo "1. Nazwa pliku: $file_name"
    echo "2. Katalog: $directory"
    echo "3. Opcje 1: $options1"
    echo "4. Opcje 2: $options2"
    echo "5. Zawartość pliku: $content"
    echo "6. Szukaj"
    echo "7. Koniec"
    read -p "Wybierz opcję: " choice

    case $choice in
        1) read -p "Podaj nazwę pliku: " file_name ;;
        2) read -p "Podaj katalog: " directory ;;
        3) read -p "Podaj pierwszą opcję wyszukiwania (np. -size +1M): " options1 ;;
        4) read -p "Podaj drugą opcję wyszukiwania (np. -mtime -7): " options2 ;;
        5) read -p "Podaj frazę do wyszukania w pliku: " content ;;
        6)
            echo "Wyszukiwanie..."

            cmd="find \"$directory\" -type f"
            if test "$file_name" != ""; then
                cmd="$cmd -name \"*$file_name*\""
            fi
            if test "$options1" != ""; then
                cmd="$cmd $options1"
            fi
            if test "$options2" != ""; then
                cmd="$cmd $options2"
            fi

            if test "$content" != ""; then
                wynik=$(eval $cmd -exec grep -q "$content" {} \; -print 2>/dev/null)
            else
                wynik=$(eval $cmd -print 2>/dev/null)
            fi

            if test "$wynik" = ""; then
                echo "Plik nie istnieje."
            else
                echo "Plik istnieje."
            fi

            read -p "Naciśnij Enter, aby kontynuować"
            ;;
        7) exit 0 ;;
        *) echo "Nieprawidłowy wybór" ;;
    esac
done