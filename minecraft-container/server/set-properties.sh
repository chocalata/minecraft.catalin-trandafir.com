#!/bin/sh

rm -f server.properties

for var in $(printenv | grep '^MC_PROPERTY_' | cut -d= -f1); do
    value=$(printenv "$var")
    
    key=$(echo "$var" | awk -F'_' '{print $NF}' | tr '[:upper:]' '[:lower:]')
    
    echo "$key=$value" >> server.properties
done