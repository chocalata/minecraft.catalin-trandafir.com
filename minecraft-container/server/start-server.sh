#!/bin/sh
java -Xmx${MC_MAX_RAM:-2G} -Xms${MC_MIN_RAM:-1G} -jar ${MC_JAR_NAME:-server.jar} nogui
