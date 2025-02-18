row_count=$(psql -h $host -p $port -U $user -d $dbname -t -c "SELECT COUNT(*) FROM cars;")
if [ "$row_count" -eq 1 ]; then
  echo "Exactly 1 row returned"
else
  echo "Row count is not 1"
fi