#!/bin/sh

if [ -n "${MC_JAR_NAME}" ] && [ ! -f "${MC_JAR_NAME}" ]; then
    echo "Error: MC_JAR_NAME is set to '${MC_JAR_NAME}' but the file does not exist!"
    echo "Available files:"
    ls -la *.jar 2>/dev/null || echo "No JAR files found in current directory"
    exit 1
fi

# Set properties
./set-properties.sh

# Start server
./start-server.sh