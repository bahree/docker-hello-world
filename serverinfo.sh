#!/bin/sh

# Retrieve the User-Agent from environment variables
USER_AGENT="${HTTP_USER_AGENT:-}"

# Function to gather server information
get_server_info() {
    # Hostname
    HOSTNAME=$(hostname 2>/dev/null || echo "Unknown")

    # External IP Address (try ifconfig.me; fallback if unavailable)
    IP_ADDRESS=$(wget -qO- http://ifconfig.me 2>/dev/null || echo "Unavailable")

    # Date and Time
    DATE_TIME=$(date 2>/dev/null || echo "Unknown")

    # Uptime
    # busybox uptime format: "HH:MM:SS up X days, ...", we just print it as is
    UPTIME=$(uptime 2>/dev/null || echo "Unavailable")

    # Server Details (OS, Kernel version)
    SERVER_DETAILS=$(uname -a 2>/dev/null || echo "Unavailable")

    # CPU Usage: BusyBox's top doesn't have the same options. We can skip or set to Unavailable.
    CPU_USAGE="Unavailable"

    # Memory Usage (use busybox free)
    # Format of `free` in busybox might differ slightly, but generally:
    # total used free shared buffers cached
    # We'll calculate % used as (used/total)*100
    MEMORY_LINE=$(free | awk 'NR==2 {print $2" "$3}')
    if [ -n "$MEMORY_LINE" ]; then
        TOTAL_MEM=$(echo "$MEMORY_LINE" | awk '{print $1}')
        USED_MEM=$(echo "$MEMORY_LINE" | awk '{print $2}')
        if [ "$TOTAL_MEM" -gt 0 ]; then
            MEMORY_USAGE=$(awk -v used="$USED_MEM" -v total="$TOTAL_MEM" 'BEGIN {printf "%.2f%%", (used/total)*100}')
        else
            MEMORY_USAGE="Unavailable"
        fi
    else
        MEMORY_USAGE="Unavailable"
    fi

    # Disk Usage (for root filesystem)
    DISK_USAGE=$(df -h / 2>/dev/null | awk 'NR==2{print $5}' || echo "Unavailable")
    [ -z "$DISK_USAGE" ] && DISK_USAGE="Unavailable"

    # Network Interfaces: BusyBox ifconfig output: "inet addr:192.168.1.10 ..."
    # Extract all "inet addr:" occurrences.
    NETWORK_INTERFACES=$(ifconfig 2>/dev/null | awk '/inet addr/{split($2,a,":"); print a[2]}' | paste -sd ", " -)
    [ -z "$NETWORK_INTERFACES" ] && NETWORK_INTERFACES="Unavailable"

    # Container ID if running in Docker (optional)
    CONTAINER_ID=$(cat /proc/self/cgroup 2>/dev/null | grep "docker" | sed 's/^.*\///' | tail -n1)
    [ -z "$CONTAINER_ID" ] && CONTAINER_ID="Not in Docker container"
}

# Gather server information
get_server_info

# Determine output based on User-Agent
case "$USER_AGENT" in
    *curl*)
        # Serve plain text for curl requests
        echo "Content-Type: text/plain"
        echo ""
        echo "Server Information:"
        echo "-------------------"
        echo "Hostname: $HOSTNAME"
        echo "IP Address: $IP_ADDRESS"
        echo "Date and Time: $DATE_TIME"
        echo "Uptime: $UPTIME"
        echo "Server Details: $SERVER_DETAILS"
        echo "CPU Usage: $CPU_USAGE"
        echo "Memory Usage: $MEMORY_USAGE"
        echo "Disk Usage: $DISK_USAGE"
        echo "Network Interfaces: $NETWORK_INTERFACES"
        echo "Container ID: $CONTAINER_ID"
        ;;
    *)
        # Serve JSON for browser requests
        echo "Content-Type: application/json"
        echo ""
        echo "{"
        echo "  \"hostname\": \"${HOSTNAME}\","
        echo "  \"ip_address\": \"${IP_ADDRESS}\","
        echo "  \"date_time\": \"${DATE_TIME}\","
        echo "  \"uptime\": \"${UPTIME}\","
        echo "  \"server_details\": \"${SERVER_DETAILS}\","
        echo "  \"cpu_usage\": \"${CPU_USAGE}\","
        echo "  \"memory_usage\": \"${MEMORY_USAGE}\","
        echo "  \"disk_usage\": \"${DISK_USAGE}\","
        echo "  \"network_interfaces\": \"${NETWORK_INTERFACES}\","
        echo "  \"container_id\": \"${CONTAINER_ID}\""
        echo "}"
        ;;
esac
