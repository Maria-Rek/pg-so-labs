#!/bin/bash

file_name=""
directory="/"
option1=""
option2=""
content=""

while true; do
    clear
    echo "1. Nazwa pliku: $file_name"
    echo "2. Katalog: $directory"
    echo "3. Opcja 1: $option1"
    echo "4. Opcja 2: $option2"
    echo "5. Zawartość pliku: $content"
    echo "6. Szukaj"
    echo "7. Koniec"
    read -p "Wybierz opcję: " choice

    case $choice in
        1) read -p "Podaj nazwę pliku: " file_name ;;
        2)
            read -p "Podaj katalog (Enter = /): " directory
            if [ "$directory" = "" ]; then
                directory="/"
            fi
            ;;
        3) read -p "Podaj pierwszą opcję find (np. -size +1M): " option1 ;;
        4) read -p "Podaj drugą opcję find (np. -mtime -7): " option2 ;;
        5) read -p "Podaj frazę do wyszukania w pliku: " content ;;
        6)
            echo "Wyszukiwanie..."

            # Budujemy polecenie find jako tablicę
            args=( "$directory" -type f )

            if [ "$file_name" != "" ]; then
                args+=( -name "*$file_name*" )
            fi
            if [ "$option1" != "" ]; then
                args+=( $option1 )
            fi
            if [ "$option2" != "" ]; then
                args+=( $option2 )
            fi

            # Wykonanie find z grepem (jeśli podano zawartość)
            if [ "$content" != "" ]; then
                find "${args[@]}" -exec grep -q "$content" {} \; -print 2>/dev/null > temp_result.txt
            else
                find "${args[@]}" -print 2>/dev/null > temp_result.txt
            fi

            if [ -s temp_result.txt ]; then
                echo "Plik istnieje."
            else
                echo "Plik nie istnieje."
            fi

            rm -f temp_result.txt
            read -p "Naciśnij Enter, aby kontynuować"
            ;;
        7) exit 0 ;;
        *) echo "Nieprawidłowy wybór";;
    esac
done