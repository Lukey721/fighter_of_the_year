#!/bin/sh

# Wait for frontend to be available
echo "Waiting for frontend to be available..."
until wget --spider -q http://frontend-green:3000; do
  echo "Still waiting..."
  sleep 2
done

echo "Frontend is up! Starting tests..."

# Run both smoke check and performance test
k6 run /tests/smoke_check.js
k6 run /tests/perf_tests2.js