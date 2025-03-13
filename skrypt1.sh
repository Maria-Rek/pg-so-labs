#!/bin/bash

ftp_log="cdlinux.ftp.log"
www_log="cdlinux.www.log"

count_downloads() {
    local log_file=$1
    awk '{print $1, $0}' "$log_file" | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ .*cdlinux-[^ ]+\.iso' | \
    awk '{print $2, $1}' | sort | uniq | awk '{print $1}' | sort | uniq -c
}

echo "Wyniki z FTP:"
count_downloads "$ftp_log"

echo -e "\nWyniki z WWW:"
count_downloads "$www_log"

echo -e "\nWyniki sumaryczne:"
count_downloads <(cat "$ftp_log" "$www_log")
