#!/bin/bash

file_name=""
directory="/"
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
        2)
            read -p "Podaj katalog (np. /home/203174): " input_dir
            if [ -d "$input_dir" ]; then
                directory="$input_dir"
            else
                echo "Katalog nie istnieje! Szukam w domyślnym: /"
                directory="/"
                read -p "Naciśnij Enter, aby kontynuować"
            fi
            ;;
        3) read -p "Podaj opcje wyszukiwania (np. -size +1M): " options ;;
        4) read -p "Podaj frazę do wyszukania w pliku: " content ;;
        5)
            echo "Wyszukiwanie..."

            # Tworzymy polecenie find jako tablicę
            args=( "$directory" -type f )

            [ -n "$file_name" ] && args+=( -name "*$file_name*" )
            [ -n "$options" ] && args+=( $options )

            if [ -n "$content" ]; then
                wynik=$(find "${args[@]}" -exec grep -q "$content" {} \; -print 2>/dev/null)
            else
                wynik=$(find "${args[@]}" -print 2>/dev/null)
            fi

            if [ -n "$wynik" ]; then
                echo "Plik istnieje."
            else
                echo "Plik nie istnieje."
            fi

            read -p "Naciśnij Enter, aby kontynuować"
            ;;
        6) exit 0 ;;
        *) echo "Nieprawidłowy wybór." ;;
    esac
done