#!/bin/bash

# Function to get CPU usage as a percentage (integer)
get_cpu_usage() {
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'.' -f1)
    cpu_usage=$((100 - cpu_idle))
    echo "$cpu_usage"
}

# Function to get Memory usage as a percentage (integer)
get_mem_usage() {
    mem_info=$(free | grep Mem)
    total_mem=$(echo $mem_info | awk '{print $2}')
    used_mem=$(echo $mem_info | awk '{print $3}')
    mem_usage=$(awk "BEGIN {printf \"%d\", ($used_mem/$total_mem)*100}")
    echo "$mem_usage"
}

# Function to get Disk usage as a percentage (integer) for root partition
get_disk_usage() {
    disk_usage=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
    echo "$disk_usage"
}

# Main logic
CPU_USAGE=$(get_cpu_usage)
MEM_USAGE=$(get_mem_usage)
DISK_USAGE=$(get_disk_usage)

STATUS="Healthy"
REASON=""

if [ "$CPU_USAGE" -gt 60 ] || [ "$MEM_USAGE" -gt 60 ] || [ "$DISK_USAGE" -gt 60 ]; then
    STATUS="Not healthy"
fi

if [[ "$1" == "explain" ]]; then
    REASON="Reason(s):"
    if [ "$CPU_USAGE" -gt 60 ]; then
        REASON="$REASON CPU usage is ${CPU_USAGE}% (>60%)."
    else
        REASON="$REASON CPU usage is ${CPU_USAGE}% (<=60%)."
    fi
    if [ "$MEM_USAGE" -gt 60 ]; then
        REASON="$REASON Memory usage is ${MEM_USAGE}% (>60%)."
    else
        REASON="$REASON Memory usage is ${MEM_USAGE}% (<=60%)."
    fi
    if [ "$DISK_USAGE" -gt 60 ]; then
        REASON="$REASON Disk usage is ${DISK_USAGE}% (>60%)."
    else
        REASON="$REASON Disk usage is ${DISK_USAGE}% (<=60%)."
    fi
    echo "VM Health Status: $STATUS"
    echo "$REASON"
else
    echo "VM Health Status: $STATUS"
fi

exit 0
