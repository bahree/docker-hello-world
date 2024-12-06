#!/bin/sh

echo "Content-Type: application/json"
echo ""

# Get server information
HOSTNAME=$(cat /etc/hostname)
IP_ADDRESS=$(wget -qO- http://ifconfig.me)
DATE_TIME=$(date)
UPTIME=$(uptime)
SERVER_DETAILS=$(uname -a)

# Create JSON response
echo "{"
echo "  \"hostname\": \"${HOSTNAME}\","
echo "  \"ip_address\": \"${IP_ADDRESS}\","
echo "  \"date_time\": \"${DATE_TIME}\","
echo "  \"uptime\": \"${UPTIME}\","
echo "  \"server_details\": \"${SERVER_DETAILS}\""
echo "}"