#!/bin/bash

# Credentials File Path
TOKEN=""  
  
# Get Credentials
readCredentials() {
    echo " -> reading credentials..."
    
    if [ -z "$1" ]; then
        echo "Error: Credentials file path not provided."
        exit 1
    fi
    
    cpath=$1

    if [ -f "$1" ]; then
        # If it's a file, read credentials from the file
        while IFS= read -r line
        do    
            echo $line
            TOKEN=$line
        done < "$cpath" 
    else
        # If it's not a file, treat it as a token string
        TOKEN=$cpath
    fi  

    echo $TOKEN 
}

# Login using TOKEN and create cluster 
createCluster() {
    echo -e "\n -> verifying credentials \n"
    
    cname=$1  

    rosa login --token="$TOKEN" || { echo "ROSA login failed"; exit 1; }
    
    rosa verify quota || { echo "ROSA verify quota failed"; exit 1; }
    
    rosa create account-roles --mode auto --yes || { echo "ROSA account creation failed"; exit 1; }

    #rosa create cluster --cluster-name $cname --sts --mode auto --yes --watch
    ##
    #rosa logs install -c $cname --watch
    rosa describe cluster --cluster=$cname

    # check exit status of the commands 
    if [ $? -eq 0 ]; then
        echo -e "\n -> ROSA Cluster $cname created \n" 
    else
        echo "ROSA cluster creation failed with exit status $?."
    fi
}

# Check if rosa command is available 
if command -v rosa > /dev/null; then
    echo "Cluster Name in Script: " $1
    echo "Credentials: " $2
    #echo -e "rosa found!\n\n"   
    readCredentials $2 
    #createCluster $1 
else
    echo "rosa not found. Exiting..."
    exit 1
fi
 
