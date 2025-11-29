#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <server_folder>"
    exit 1
fi

server_folder=${1}

ls -A "$server_folder" | grep -v "server.jar*" | xargs rm -rf