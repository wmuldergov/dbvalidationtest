#!/bin/bash

# Function to create the PostgreSQL cluster
create_cluster() {
    echo "Creating PostgreSQL cluster..."
    oc project
    oc apply -f /db/postgrescluster.yaml
    echo "Cluster created."
}

# Function to validate the PostgreSQL cluster
validate_cluster() {
    echo "Validating PostgreSQL cluster..."
    # You can customize the validation logic here. For example:
    oc get postgrescluster
    echo "Cluster validation complete."
}

# Function to delete the PostgreSQL cluster
delete_cluster() {
    echo "Deleting PostgreSQL cluster..."
    oc delete -f /db/postgrescluster.yaml
    echo "Cluster deleted."
}

# Ask the user for action
echo "Please select an action:"
echo "1. Create PostgreSQL Cluster"
echo "2. Validate PostgreSQL Cluster"
echo "3. Delete PostgreSQL Cluster"
echo "4. Exit"

while true; do
    read -p "Enter the number of your choice: " choice
    case $choice in
        1)
            create_cluster
            ;;
        2)
            validate_cluster
            ;;
        3)
            delete_cluster
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice, please select 1, 2, 3, or 4."
            ;;
    esac
done