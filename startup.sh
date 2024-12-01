#!/bin/sh

# Get the hostname
HOSTNAME=$(hostname)

# Get the IP address
IP_ADDRESS=$(hostname -i)

# Get server details
SERVER_DETAILS=$(uname -a)

# Get current date and time
DATE_TIME=$(date)

# Get system uptime
UPTIME=$(uptime)

# Get disk usage
DISK_USAGE=$(df -h)

# Generate index.html
cat <<EOF > /www/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Container Info</title>
</head>
<body>
    <h1>Container Information</h1>
    <p><strong>Hostname:</strong> ${HOSTNAME}</p>
    <p><strong>IP Address:</strong> ${IP_ADDRESS}</p>
    <p><strong>Server Details:</strong> ${SERVER_DETAILS}</p>
    <p><strong>Date and Time:</strong> ${DATE_TIME}</p>
    <p><strong>System Uptime:</strong> ${UPTIME}</p>
    <h2>Disk Usage:</h2>
    <pre>${DISK_USAGE}</pre>
    <pre>
      ##         .
    ## ## ##        ==
 ## ## ## ## ##    ===
/""""""""""""""""\___/ ===
{~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
 \______ o          _,/
  \      \       _,'
   `'--.._\..--''
    </pre>
</body>
</html>
EOF