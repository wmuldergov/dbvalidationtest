#!/bin/bash

# Function to create the PostgreSQL cluster
create_cluster() {
    echo "Creating PostgreSQL cluster..."
    oc project
    oc apply -f /db/postgrescluster.yaml
    echo "Cluster created."
}

# Function to get the PostgreSQL cluster details
get_clusterVariables() {
    secretName="hippo-pguser-hippo"
    clusterName="hippo"

    host=$(oc get secret $secretName -o jsonpath='{.data.host}' | base64 -d)
    port=$(oc get secret $secretName -o jsonpath='{.data.port}' | base64 -d)
    user=$(oc get secret $secretName -o jsonpath='{.data.user}' | base64 -d)
    password=$(oc get secret $secretName -o jsonpath='{.data.password}' | base64 -d)
    dbname=$(oc get secret $secretName -o jsonpath='{.data.dbname}' | base64 -d)
    export PGPASSWORD=$password
}

# Prep Cluster
prep_cluster() {
    echo "Prepping Cluster with Sample Data..."
    psql -h $host -p $port -U $user -d $dbname -f scripts/prepCluster.sql
}


# Function to validate the PostgreSQL cluster
validate_cluster() {
    echo "Validating PostgreSQL cluster..."
    row_count=$(psql -h $host -p $port -U $user -d $dbname -t -c "SELECT COUNT(*) FROM cars;")
    if [ "$row_count" -eq 1 ]; then
    echo "Exactly 1 row returned"
    else
    echo "Row count is not 1"
    fi
    echo "Cluster validation complete."
}

# Function to delete the PostgreSQL cluster
delete_cluster() {
    echo "Deleting PostgreSQL cluster..."
    oc delete postgrescluster $clusterName
    echo "Cluster deleted."
}

# Ask the user for action
echo "Please select an action:"
echo "1. Create PostgreSQL Cluster"
echo "2. Get PostgreSQL Cluster Variables"
echo "3. Prep Cluster"
echo "4. Validate PostgreSQL Cluster"
echo "5. Delete PostgreSQL Cluster"
echo "6. Exit"

while true; do
    read -p "Enter the number of your choice: " choice
    case $choice in
        1)
            create_cluster
            ;;
        2)
            get_clusterVariables
            ;;
        3)
            prep_cluster
            ;;
        4)
            validate_cluster
            ;;
        5)
            delete_cluster
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice, please select 1, 2, 3, 4, 5 or 6."
            ;;
    esac
done