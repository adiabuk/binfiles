#!/bin/bash

# Get public IP address

set -eu
set -o pipefail
result=`wget -qO- http://ipecho.net/plain` || echo "No Address"
echo $result | grep -qi html && echo "No Address" && exit 1
echo $result && echo
