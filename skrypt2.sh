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
    echo -n "Wybierz opcję: "
    read choice
    
    case $choice in
        1)
            echo -n "Podaj nazwę pliku: "
            read file_name
            ;;
        2)
            echo -n "Podaj katalog (domyślnie /): "
            read directory
            [ -z "$directory" ] && directory="/"
            ;;
        3)
            echo -n "Podaj opcje wyszukiwania (np. -size +1M, -mtime -7): "
            read options
            ;;
        4)
            echo -n "Podaj frazę do wyszukania w pliku: "
            read content
            ;;
        5)
            echo "Wyszukiwanie..."
            find_command="find \"$directory\" -type f"
            [ -n "$file_name" ] && find_command+=" -name \"*$file_name*\""
            [ -n "$options" ] && find_command+=" $options"
            
            eval $find_command > results.txt
            
            if [ -n "$content" ]; then
                grep -l "$content" $(cat results.txt) 2>/dev/null > results_filtered.txt
                cat results_filtered.txt
            else
                cat results.txt
            fi
            echo "Naciśnij Enter, aby kontynuować..."
            read
            ;;
        6)
            echo "Koniec programu."
            exit 0
            ;;
        *)
            echo "Nieprawidłowy wybór!"
            ;;
    esac
done
