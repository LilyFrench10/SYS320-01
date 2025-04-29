#!/bin/bash

report="report.txt"
output="/var/www/html/report.html"

if [[ ! -f "$report" ]]; then
  echo "Error: $report not found!"
  exit 1
fi

# Create HTML
{
  echo "<html>"
  echo "<body>"
  echo "<h2>Indicators of Compromise (IOC) Report</h2>"
  echo "<table border='1'>"
  echo "<tr><th>IP Address</th><th>Date/Time</th><th>Page Accessed</th></tr>"

  while IFS= read -r line; do
    ip=$(echo "$line" | awk '{print $1}')
    datetime=$(echo "$line" | awk '{print $2}')
    timeoffset=$(echo "$line" | awk '{print $3}')
    page=$(echo "$line" | cut -d' ' -f4-)
    echo "<tr><td>$ip</td><td>$datetime $timeoffset</td><td>$page</td></tr>"
  done < "$report"

  echo "</table>"
  echo "</body>"
  echo "</html>"
} > "$output"

echo "HTML report generated at $output"
