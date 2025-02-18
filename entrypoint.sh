#!/bin/bash

# Define metrics file path
METRICS_FILE="/tmp/metrics"

# Start an infinite loop to refresh metrics
while true; do
  # Run PostgreSQL query and get the row count
  row_count=0

  # Write the metric to a file
  cat << EOF > "$METRICS_FILE"
# HELP cars_row_count Total number of rows in the 'cars' table.
# TYPE cars_row_count gauge
cars_row_count $row_count
EOF

  # Sleep before updating again (adjust if needed)
  sleep 10
done &  # Run in the background

# Serve the /metrics file using Python's built-in HTTP server
cd /tmp && exec python3 -m http.server 8080
