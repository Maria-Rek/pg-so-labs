#!/bin/bash

echo "FTP:"
cat cdlinux.ftp.log | grep "OK DOWNLOAD" | cut -d '"' -f 2,4 | sort | uniq | cut -d '"' -f 2 | grep -o "cdlinux-.*\.iso" | sed "s#.*/##" | sort | uniq -c | sort -rn

echo -e "\nWWW:"
cat cdlinux.www.log | cut -d " " -f 1,7,9 | grep '200$' | sort | uniq | cut -d " " -f 2 | grep -o "cdlinux-.*\.iso" | sed "s#.*/##" | sort | uniq -c | sort -rn

echo -e "\nSumaryczne:"
( 
    cat cdlinux.ftp.log | grep "OK DOWNLOAD" | cut -d '"' -f 2,4 | sort | uniq | cut -d '"' -f 2 | grep -o "cdlinux-.*\.iso" | sed "s#.*/##"
    cat cdlinux.www.log | cut -d " " -f 1,7,9 | grep '200$' | sort | uniq | cut -d " " -f 2 | grep -o "cdlinux-.*\.iso" | sed "s#.*/##"
) | sort | uniq -c | sort -rn
