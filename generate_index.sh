#!/bin/sh

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')
DATE=$(date)

# Replace placeholders in the template with actual values
sed -e "s/{{HOSTNAME}}/${HOSTNAME}/" \
    -e "s/{{IP}}/${IP}/" \
    -e "s/{{DATE}}/${DATE}/" \
    /www/index.html.template > /www/index.html
