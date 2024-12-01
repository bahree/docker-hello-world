#!/bin/sh

# Log access details
echo "Accessed serverinfo.sh at $(date) from IP: $(echo $REMOTE_ADDR || echo 'N/A')" >&2

# Output CGI headers
echo "Content-type: application/json"
echo ""

# Generate server information in JSON format
echo "{"
echo "\"hostname\": \"$(hostname)\","
echo "\"ip_address\": \"$(hostname -i)\","
echo "\"date_time\": \"$(date)\","
echo "\"uptime\": \"$(uptime)\","
echo "\"server_details\": \"$(uname -a)\""
echo "}"