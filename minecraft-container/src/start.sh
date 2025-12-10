#!/bin/sh

src_folder="/minecraft_server"

server_folder="$src_folder/server"

server_jar="$server_folder/server.jar"

# Delete server data if flag is set
if [ "${MC_DELETE_SERVER}" = "true" ]; then
    echo "Deleting existing server data..."
    "$src_folder/delete-server.sh" "$server_folder"
fi

if [ ! -f "$server_jar" ]; then
    echo "Error: the file server.jar does not exist!"
    echo "Available files:"
    ls -la "$server_folder"/*.jar 2>/dev/null || echo "No JAR files found in current directory"

    # Try to get the server jar
    echo "Attempting to download the server jar..."

    "$src_folder/get-server-jar.sh" "$server_jar"
    
    if [ ! -f "$server_jar" ]; then
        echo "Failed to download the server jar. Exiting."
        exit 1
    fi
fi

# Set properties
"$src_folder/set-properties.sh" "$server_folder"

# Start server
"$src_folder/start-server.sh" "$server_jar"