#!/bin/bash

# Get public IP address
set -eu
set -o pipefail
aws='http://instance-data/latest/meta-data/public-ipv4'
if  host instance-data > /dev/null; then
  result=$(wget -q0- http://instance-data/latest/meta-data/public-ipv4);
else
  result=$(wget -qO- http://ipecho.net/plain) || echo "No Address"
fi

echo $result | grep -qi html && echo "No Address" && exit 1
echo $result && echo
