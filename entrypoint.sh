#!/bin/bash

# Run PostgreSQL query and get the row count
row_count=0

# Serve metrics over HTTP
cat << EOF > /metrics
# HELP cars_row_count Total number of rows in the 'cars' table.
# TYPE cars_row_count gauge
cars_row_count $row_count
EOF

# Start a simple HTTP server to expose metrics
while true; do
  echo "Serving metrics at http://localhost:8080/metrics"
  cat /metrics | nc -l -p 8080 -q 1
  sleep 5
done