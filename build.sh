#!/bin/bash

app="mc-server"
repository="chocalata/mc.catalin-trandafir.com"
version_file="version" 

# Configuration - easy to add more processes
declare -A process_config=(
    ["mc-server"]="./minecraft-container/ Dockerfile"
    # Add more processes like:
    # ["web-server"]="./web-container/ Dockerfile.prod"
    # ["api"]="./api/ Dockerfile"
)

processes=("${!process_config[@]}")

echo "Choose a process to build:"
select process in "${processes[@]}"; do
    [ -n "$process" ] && break
    echo "Invalid selection. Try again."
done

[ -z "$process" ] && echo "No process selected. Exiting..." && exit 1

# Get build config from array
read -r folder dockerfile <<< "${process_config[$process]}"

# Version handling
last_version=$(grep "$process" "$version_file" 2>/dev/null || true)
today=$(date +"%Y-%m-%d")

if [ -z "$last_version" ]; then
    new_version="${today}-v1"
else
    last_version_date=$(echo "$last_version" | cut -d' ' -f2 | cut -d'-' -f1-3)
    last_version_number=$(echo "$last_version" | cut -d' ' -f2 | cut -d'-' -f4- | sed 's/v//')
    
    if [ "$last_version_date" != "$today" ]; then
        new_version="${today}-v1"
    else
        new_version="${today}-v$((last_version_number + 1))"
    fi
fi

echo "Building ${app}_${new_version}..."

# Update version file
if [ -z "$last_version" ]; then
    echo "$process $new_version" >> "$version_file"
else
    sed -i "s/$last_version/$process $new_version/g" "$version_file"
fi

echo "docker buildx build --platform linux/arm64 -t \"${repository}:${app}_${new_version}\" -f \"$folder$dockerfile\" --load \"$folder\""
echo "docker push \"${repository}:${app}_${new_version}\""

# Build and push
docker buildx build --platform linux/arm64 -t "${repository}:${app}_${new_version}" -f "$folder$dockerfile" --load "$folder"
docker push "${repository}:${app}_${new_version}"