#!/bin/bash

file_name=""
directory=""
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
        2) read -p "Podaj katalog: " directory ;;
        3) read -p "Podaj pierwszą opcję (np. -size +1M): " option1 ;;
        4) read -p "Podaj drugą opcję (np. -mtime -7): " option2 ;;
        5) read -p "Podaj frazę do wyszukania w pliku: " content ;;
        6) 
            if [ ! -d "$directory" ]; then
                continue
            fi

            echo "Wyszukiwanie..."

            find_cmd="find \"$directory\" -type f"
            [ -n "$file_name" ] && find_cmd+=" -name \"*$file_name*\""
            [ -n "$option1" ] && find_cmd+=" $option1"
            [ -n "$option2" ] && find_cmd+=" $option2"

            if [ -n "$content" ]; then
                result=$(eval $find_cmd -exec grep -q "$content" {} \; -print 2>/dev/null)
            else
                result=$(eval $find_cmd -print 2>/dev/null)
            fi

            if [ -n "$result" ]; then
                echo "Plik istnieje."
            else
                echo "Plik nie istnieje."
            fi

            read -p "Naciśnij Enter, aby kontynuować"
            ;;
        7) exit 0 ;;
        *) echo "Nieprawidłowy wybór";;
    esac
done