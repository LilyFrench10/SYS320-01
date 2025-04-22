#! /bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst(){
  echo -n "Please Input an Instructor Full Name: "
  read instName

  echo ""
  echo "Courses of $instName :"
  cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | sed 's/;/ | /g'
  echo ""
}

function courseCountofInsts(){
  echo ""
  echo "Course-Instructor Distribution"
  cat "$courseFile" | cut -d';' -f7 | grep -v "/" | grep -v "\.{3}" | sort -n | uniq -c | sort -n -r 
  echo ""
}

function displayCoursesAtLocation(){
  echo -n "Please enter a location (e.g., JOYC 310): "
  read location

  echo ""
  echo "Courses at $location :"
  grep "$location" "$courseFile" | while IFS=';' read -r code title credit seats days time inst dates prereq loc; do
    echo "$code | $title | $days | $time | $inst"
  done
  echo ""
}

function displayAvailableCourses(){
  echo -n "Please enter a course code (e.g., SEC): "
  read code

  echo ""
  echo "Available sections of $code:"
  grep "$code" "$courseFile" | while IFS=';' read -r course title credit seats days time inst dates prereq loc; do
    if [[ $seats -gt 0 ]]; then
      echo "$course | $title | $days | $time | $inst | Seats: $seats"
    fi
  done
  echo ""
}

while :
  do
  echo ""
  echo "Please select an option:"
  echo "[1] Display courses of an instructor"
  echo "[2] Display course count of instructors"
  echo "[3] Display all courses in a location"
  echo "[4] Display all available courses for a course code"
  echo "[5] Exit"

  read userInput
  echo ""

  if [[ "$userInput" == "5" ]]; then
    echo "Goodbye"
    break

  elif [[ "$userInput" == "1" ]]; then
    displayCoursesofInst

  elif [[ "$userInput" == "2" ]]; then
    courseCountofInsts

  elif [[ "$userInput" == "3" ]]; then
    displayCoursesAtLocation

  elif [[ "$userInput" == "4" ]]; then
    displayAvailableCourses

  else
    echo "Invalid input. Please select a valid option from the menu."
  fi

done
