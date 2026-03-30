#!/bin/bash
set -e

mongosh init_db.js
mongosh insert_data.js
mongosh query_clients_over_30.js
mongosh query_medium_workouts.js
mongosh query_membership_by_client.js

echo "All MongoDB scripts executed successfully"
