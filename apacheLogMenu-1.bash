#! /bin/bash


logFile="/var/log/apache2/access.log"


function displayAllLogs(){
    cat "$logFile"
}


function displayOnlyIPs(){
        cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}


# function: displayOnlyPages:
# like displayOnlyIPs - but only pages
function displayOnlyPages() {
	cat "$logFile" | cut -d '"' -f2 | cut -d ' ' -f2 | sort | uniq -c
}

function histogram(){


    local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '['  | sort \
                              | uniq)
    # This is for debugging, print here to see what it does to continue:
    # echo "$visitsPerDay"


        :> newtemp.txt  # what :> does is in slides
    echo "$visitsPerDay" | while read -r line;
    do
        local withoutHours=$(echo "$line" | cut -d " " -f 2 \
                                     | cut -d ":" -f 1)
        local IP=$(echo "$line" | cut -d  " " -f 1)
         
        local newLine="$IP $withoutHours"
        echo "$IP $withoutHours" >> newtemp.txt
    done
    cat "newtemp.txt" | sort -n | uniq -c
}


# function: frequentVisitors:
# Only display the IPs that have more than 10 visits
# You can either call histogram and process the results,
# Or make a whole new function. Do not forget to separate the
# number and check with a condition whether it is greater than 10
# the output should be almost identical to histogram
# only with daily number of visits that are greater than 10
function frequentVisitors() {
	:> tempVisits.txt
	cat "$logFile" | cut -d " " -f 4,1 | tr -d '[' | sort | uniq | while read -r line; do
		local withoutHours=$(echo "$line" | cut -d " " -f 2 | cut -d ":" -f 1)
		local IP=$(echo "$line" | cut -d " " -f 1)

		echo "$IP $withoutHours" >> tempVisits.txt
	done


	cat tempVisits.txt | sort -n | uniq -c | while read -r count rest; do
		if [[ "$count" -gt 10 ]]; then
			echo "$count $rest"
		fi
	done
}

# function: suspiciousVisitors
# Manually make a list of indicators of attack (ioc.txt)
# filter the records with this indicators of attack
# only display the unique count of IP addresses.  
# Hint: there are examples in slides
function suspiciousVisitors() {
	local iocFile="ioc.txt"
	if [[ ! -f "$iocFile" ]]; then
		echo "No ioc.txt found"
		return
	fi

	:> suspicious.txt
	while read -r indicator; do
		grep "$indicator" "$logFile" >> suspicious.txt
	done < "$iocFile"

	cat suspicious.txt | cut -d ' ' -f1 | sort | uniq -c
}
# Keep in mind that I have selected long way of doing things to
# demonstrate loops, functions, etc. If you can do things simpler,
# it is welcomed.


while :
do
    echo "PLease select an option:"
    echo "[1] Display all Logs"
    echo "[2] Display only IPS"
    echo "[3] Display pages visited"
    echo "[4] Histogram"
    echo "[5] Frequent Visitors"
    echo "[6] Suspicious Visitors"
    echo "[7] Quit"


    read userInput
    echo ""


    if [[ "$userInput" == "7" ]]; then
        echo "Goodbye"      
        break


    elif [[ "$userInput" == "1" ]]; then
        echo "Displaying all logs:"
        displayAllLogs


    elif [[ "$userInput" == "2" ]]; then
        echo "Displaying only IPS:"
        displayOnlyIPs


    # Display only pages visited
    elif [[ "$userInput" == "3" ]]; then
	echo "Pages visited"
	displayOnlyPages

    elif [[ "$userInput" == "4" ]]; then
        echo "Histogram:"
        histogram


        # Display frequent visitors
    elif [[ "$userInput" == "5" ]]; then
	echo "Frequent visitors:"
	frequentVisitors
	# Display suspicious visitors
    elif [[ "$userInput" == "6" ]]; then
	echo "Suspicious visitors"
	suspiciousVisitors

    else
	echo "invalid input"
    fi
done
