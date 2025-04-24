#!/bin/bash

#my myIP.bash was named ip1.bash
myIP=$(bash ip1.bash)

function helpmenu() {
  echo "Usage: $0 -n internal|external | -s internal|external"
  echo "  -n   Use nmap (scan ports)"
  echo "  -s   Use ss (list listening processes)"
  echo "       internal = localhost only"
  echo "       external = network-visible"
  exit 1
}

function ExternalNmap() {
  nmap "$myIP" | awk -F"[/[:space:]]+" '/open/ {print $1, $4}'
}

function InternalNmap() {
  nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1, $4}'
}

function ExternalListeningPorts() {
  ss -ltpn | awk -F"[[:space:]:(),]+" '$5 !~ /^127\.0\.0\.1$/ && $1 == "LISTEN" {print $5, $9}' | tr -d "\""
}

function InternalListeningPorts() {
  ss -ltpn | awk -F"[[:space:]:(),]+" '$5 ~ /^127\.0\.0\.1$/ && $1 == "LISTEN" {print $5, $9}' | tr -d "\""
}

# Check for both inputs
if [ "$#" -ne 2 ]; then
  helpmenu
fi

#Option selection
case "$1" in
  -n)
    case "$2" in
      internal) InternalNmap ;;
      external) ExternalNmap ;;
      *) helpmenu ;;
    esac
    ;;
  -s)
    case "$2" in
      internal) InternalListeningPorts ;;
      external) ExternalListeningPorts ;;
      *) helpmenu ;;
    esac
    ;;
  *)
    helpmenu
    ;;
esac
