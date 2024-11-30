#!/bin/sh

export HOSTNAME=$(hostname)
export IP=$(hostname -I | awk '{print $1}')
export DATE=$(date)

# Replace placeholders in the template with actual values
envsubst < /www/index.html.template > /www/index.html
