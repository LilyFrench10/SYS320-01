#!/bin/bash

url="http://10.0.17.6/IOC.html"

file="IOC.txt"

curl -s "$url" | \
grep -oP '(?<=<td>).*?(?=</td>)' | \
awk 'NR % 2 ==1' > "$file"

cat IOC.txt
