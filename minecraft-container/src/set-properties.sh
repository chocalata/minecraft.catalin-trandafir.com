#!/bin/sh

server_folder=${1}
properties_file="$server_folder/server.properties"

if [ -f "$properties_file" ] && [ -s "$properties_file" ]; then
    temp_file=$(mktemp)

    cp "$properties_file" "$temp_file"
    
    # Update or add each property
    for var in $(printenv | grep '^MC_PROPERTY_' | cut -d= -f1); do
        value=$(printenv "$var")

        key=$(echo "$var" | sed 's/^MC_PROPERTY_//' | tr '[:upper:]' '[:lower:]' | tr '_' '-')
        
        awk -v key="$key" -v value="$value" '
            $0 ~ "^" key "=" { found=1; print key "=" value; next }
            { print }
            END { if (!found) print key "=" value }
        ' "$temp_file" > "$temp_file.tmp"
        
        mv "$temp_file.tmp" "$temp_file"
    done
    
    # Replace original file
    mv "$temp_file" "$properties_file"

else
    rm -f "$properties_file"
    for var in $(printenv | grep '^MC_PROPERTY_' | cut -d= -f1); do
        value=$(printenv "$var")
        key=$(echo "$var" | sed 's/^MC_PROPERTY_//' | tr '[:upper:]' '[:lower:]' | tr '_' '-')
        echo "$key=$value" >> "$properties_file"
    done
fi