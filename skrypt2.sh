#!/bin/bash

file_name=""
directory=""
options=""
content=""

while true; do
    clear
    echo "1. Nazwa pliku: $file_name"
    echo "2. Katalog: $directory"
    echo "3. Opcje wyszukiwania: $options"
    echo "4. Zawartość pliku: $content"
    echo "5. Szukaj"
    echo "6. Koniec"
    read -p "Wybierz opcję: " choice

    case $choice in
        1) read -p "Podaj nazwę pliku: " file_name ;;
        2) read -p "Podaj katalog: " directory ;;
        3) read -p "Podaj opcje wyszukiwania (np. -size +1M): " options ;;
        4) read -p "Podaj frazę do wyszukania w pliku: " content ;;
        5) 
            echo "Wyszukiwanie"
            find_cmd="find \"$directory\" -type f"
            [ -n "$file_name" ] && find_cmd+=" -name \"*$file_name*\""
            [ -n "$options" ] && find_cmd+=" $options"
            
            result=$(eval $find_cmd 2>/dev/null)

            if [ -n "$content" ]; then
                echo "$result" | xargs grep -l "$content" 2>/dev/null
            else
                echo "$result"
            fi

            read -p "Naciśnij Enter, aby kontynuować"
            ;;
        6) exit 0 ;;
        *) echo "Nieprawidłowy wybór";;
    esac
done
