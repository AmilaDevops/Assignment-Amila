#!/bin/bash
#AUTHOR - Amila G

CIDR_JSON=$(curl -s https://FDQN/vend_ip)
IP_ADDRESS=$(echo $CIDR_JSON | jq -r '.ip_address')
SUBNET_SIZE=$(echo $CIDR_JSON | jq -r '.subnet_size')

echo "Retrieved CIDR: $IP_ADDRESS$SUBNET_SIZE"

# Exporting for Terraform consumption
export TF_VAR_cidr_block="$IP_ADDRESS$SUBNET_SIZE"