#!/bin/bash

# Define metrics file path
METRICS_FILE="/tmp/metrics"

# Ensure the script runs indefinitely and updates the metrics file periodically
while true; do
  # Run PostgreSQL query and get the row count
  row_count=0

  # Write the metric to a file
  cat << EOF > "$METRICS_FILE"
# HELP cars_row_count Total number of rows in the 'cars' table.
# TYPE cars_row_count gauge
cars_row_count $row_count
EOF

  # Serve metrics over HTTP using netcat
  echo "Serving metrics at http://localhost:8080/metrics"
  while true; do cat "$METRICS_FILE" | nc -l -p 8080 -q 1; done

  # Sleep before updating again (optional, adjust as needed)
  sleep 10
done
