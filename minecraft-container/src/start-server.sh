#!/bin/sh

server_jar=${1}

java -Xmx${MC_MAX_RAM:-2G} -Xms${MC_MIN_RAM:-1G} -jar "$server_jar" nogui
