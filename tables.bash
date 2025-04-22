#!/bin/bash

# Get HTML from the page and flatten it
html=$(curl -s http://10.0.17.6/Assignment.html)


# Extract temperature table rows and get the first <td> values
temps=$(echo "$html" | awk '/<table id="temp">/,/<\/table>/' |
  grep '<td>' | awk 'NR % 2 == 1 {gsub(/<[^>]*>/, "", $0); print $1 }')



# Extract pressure table rows and get the first <td> values
pressures=$(echo "$html" | awk '/<table id="press">/,/<\/table>/' |
   grep '<td>' | awk 'NR % 2 == 1 {gsub(/<[^>]*>/, "", $0); print $1 }')


# Extract date-time values (same for both tables)
datetimes=$(echo "$html" |
  grep -oP '<td>[0-9]+/[0-9]+/[0-9]+-[^<]+</td>' |
  sed -E 's|<td>([^<]+)</td>|\1|')



# Convert to arrays
readarray -t temp_arr <<< "$temps"
readarray -t press_arr <<< "$pressures"
readarray -t time_arr <<< "$datetimes"

# Get total rows (from temperature, could also use date/time or pressure)
count=${#temp_arr[@]}

# Loop and print merged output
for ((i=0; i<$count; i++)); do
  echo "${time_arr[$i]}"
  echo "Temperature: ${temp_arr[$i]}"
  echo "Pressure: ${press_arr[$i]}"
  echo ""
done
