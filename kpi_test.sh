#!/bin/bash

# Description: Collects latency, packet loss, throughput, and appends to a JSON file.

SITE_ID="Site-A"
IPERF_SERVER="iperf.server.ip"   #I cant provide the ip here ... its private
RESULT_FILE="/home/gimec/kpi_result.json"
TIMESTAMP=$(date -Iseconds)

# Run mtr for latency and packet loss
MTR_OUTPUT=$(mtr -r -c 10 ${IPERF_SERVER} | tail -1)
LATENCY=$(echo "$MTR_OUTPUT" | awk '{print $8}')
PACKET_LOSS=$(echo "$MTR_OUTPUT" | awk '{print $7}' | tr -d '%')

# Run iperf3 for throughput
IPERF_OUTPUT=$(iperf3 -c ${IPERF_SERVER} -f m -t 5)
THROUGHPUT=$(echo "$IPERF_OUTPUT" | grep "receiver" | awk '{print $(NF-1)}')

# Default to 0 if empty
THROUGHPUT=${THROUGHPUT:-0}
LATENCY=${LATENCY:-0}
PACKET_LOSS=${PACKET_LOSS:-0}

# Create JSON object
NEW_ENTRY=$(cat <<EOF
{
  "timestamp": "$TIMESTAMP",
  "site_id": "$SITE_ID",
  "latency_ms": $LATENCY,
  "packet_loss_pct": $PACKET_LOSS,
  "throughput_tcp_mbps": $THROUGHPUT
}
EOF
)

# Append safely into JSON array
if [[ ! -f "$RESULT_FILE" || ! -s "$RESULT_FILE" ]]; then
    echo "[$NEW_ENTRY]" > "$RESULT_FILE"
else
    sed -i '$ s/]$//' "$RESULT_FILE"
    echo ", $NEW_ENTRY]" >> "$RESULT_FILE"
fi
