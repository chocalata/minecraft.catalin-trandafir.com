#!/bin/sh

server_folder=${1}

java -Xmx${MC_MAX_RAM:-2G} -Xms${MC_MIN_RAM:-1G} -jar "$server_folder/server.jar" nogui
