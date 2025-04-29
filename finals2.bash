#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 access.log IOC.txt"
  exit 1
fi

log="$1"
ioc="$2"
report="report.txt"

if [[ ! -f "$log" || ! -f "$ioc" ]]; then
  echo "No log or ioc file"
  exit 1
fi

> "$report"


while IFS= read -r logline; do
  while IFS= read -r pattern; do
    if [[ "$logline" == *"$pattern"* ]]; then
      ip=$(echo "$logline" | awk '{print $1}')
      datetime=$(echo "$logline" | awk '{print $4 " " $5}' | sed 's/\[//;s/\]//')
      request=$(echo "$logline" | sed -n 's/.*GET \(\/[^ ]*\) HTTP.*/\1/p')
      echo "$ip $datetime $request" >> "$report"
      break
    fi
  done < "$ioc"
done < "$log"

echo "IOC matches saved to $report"



cat report.txt
