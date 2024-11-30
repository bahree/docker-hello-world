#!/bin/sh

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')
DATE=$(date)

# Replace placeholders in the template with actual values
envsubst < /www/index.html.template > /www/index.html
