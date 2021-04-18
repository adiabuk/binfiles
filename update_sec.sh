#!/bin/bash
# Update existing security group with new public IP
# to allow incoming SSH access

ip=$(publicip.sh)
AWS_PROFILE=gc aws ec2 authorize-security-group-ingress --group-name ssh \
 --protocol tcp --port 22 --cidr ${ip}/32
