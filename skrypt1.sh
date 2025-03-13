#!/bin/bash

cat cdlinux.ftp.log | grep "OK" | cut -d '"' -f 2,4 | sort | uniq | cut -d '"' -f 2 | grep -o "cdlinux-.*" | sed "s#?.*##" | sort > wynik.txt
cat cdlinux.www.log | cut -d " " -f 1,7,9 | grep '200$' | sort | uniq | cut -d " " -f 2 | grep -o "cdlinux-.*" | sed "s#?.*##" | sort >> wynik.txt
cat wynik.txt | sort | uniq -c | sort -rn
