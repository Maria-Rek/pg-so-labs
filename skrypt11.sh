#!/bin/bash

echo "Wyniki z FTP:"
cat cdlinux.ftp.log | grep "OK" | cut -d '"' -f 2,4 | sort | uniq | cut -d '"' -f 2 | grep -o "cdlinux-.*\.iso" | sed "s#?.*##" | sort | uniq -c | sort -rn

echo -e "\nWyniki z WWW:"
cat cdlinux.www.log | cut -d " " -f 1,7,9 | grep '200$' | sort | uniq | cut -d " " -f 2 | grep -o "cdlinux-.*\.iso" | sed "s#?.*##" | sort | uniq -c | sort -rn

echo -e "\nWyniki sumaryczne:"
cat cdlinux.ftp.log cdlinux.www.log | grep -E 'OK| 200$' | awk '{print $2}' | grep -o "cdlinux-.*\.iso" | sed "s#?.*##" | sort | uniq -c | sort -rn
