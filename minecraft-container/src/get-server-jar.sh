#!/bin/sh

# Simple Minecraft server downloader.
# Set MC_VERSION environment variable to specify which version to download.

# ========== CONFIGURATION ==========
# Get version from environment variable or use default
VERSION="${MC_VERSION:-latest}"
# ===================================

# ========== CONSTANTS ==========
MANIFEST_URL="https://launchermeta.mojang.com/mc/game/version_manifest.json"
TIMEOUT=60
OUTPUT_FILENAME="${1:-server.jar}"
PROGRESS_FORMAT="Progress: %.2f%% (%d MB)"
# ===============================

# Function to print error and exit
error_exit() {
    echo -e "\033[31m✗ $1\033[0m" >&2
    exit 1
}

# Function to print info
print_info() {
    echo -e "\033[32m$1\033[0m"
}

# Function to print warning
print_warning() {
    echo -e "\033[33m$1\033[0m"
}

# Check dependencies
command -v curl >/dev/null 2>&1 || error_exit "curl is required but not installed"
command -v jq >/dev/null 2>&1 || error_exit "jq is required but not installed"

echo "Starting Minecraft server download..."

# Show which version we're using
if [[ "$VERSION" == "latest" ]]; then
    print_warning "Using 'latest' version (no MC_VERSION environment variable set)"
else
    echo "MC_VERSION environment variable set to: $VERSION"
fi

# 1. Get version manifest with timeout
echo "Fetching version manifest..."
manifest_json=$(curl -s --max-time $TIMEOUT "$MANIFEST_URL") || error_exit "Failed to fetch version manifest"

# 2. Determine target version
if [[ "$VERSION" == "latest" ]]; then
    target_version=$(echo "$manifest_json" | jq -r '.latest.release')
    echo "Latest version detected: $target_version"
else
    target_version="$VERSION"
fi

echo "Target version: $target_version"

# 3. Check if version exists in manifest
version_exists=$(echo "$manifest_json" | jq -r '.versions[] | select(.id == "'"$target_version"'") | .id')
if [[ -z "$version_exists" ]]; then
    # Get recent versions for error message
    recent_versions=$(echo "$manifest_json" | jq -r '[.versions[] | select(.type == "release") | .id][:10] | join(", ")')
    error_exit "Version '$target_version' not found. Recent versions: $recent_versions"
fi

# 4. Get version details URL
echo "Getting version details for $target_version..."
version_url=$(echo "$manifest_json" | jq -r '.versions[] | select(.id == "'"$target_version"'") | .url')

version_data=$(curl -s --max-time $TIMEOUT "$version_url") || error_exit "Failed to fetch version details"

# 5. Extract download URL
download_url=$(echo "$version_data" | jq -r '.downloads.server.url')
echo "Download URL retrieved"

# 6. Download the server JAR with progress
echo "Downloading $OUTPUT_FILENAME..."

# Download with curl showing progress
curl -L --progress-bar --max-time $TIMEOUT "$download_url" -o "$OUTPUT_FILENAME" || error_exit "Failed to download server.jar"

# Get file size for display
if [[ -f "$OUTPUT_FILENAME" ]]; then
    file_size=$(stat -f%z "$OUTPUT_FILENAME" 2>/dev/null || stat -c%s "$OUTPUT_FILENAME" 2>/dev/null)
    file_size_mb=$((file_size / 1024 / 1024))
    
    print_info "✓ Successfully downloaded $OUTPUT_FILENAME"
    echo "File size: ${file_size_mb} MB"
    
    # Print summary
    echo ""
    echo "========================================"
    print_info "DOWNLOAD SUMMARY:"
    echo "  Version: $target_version"
    echo "  File: $OUTPUT_FILENAME"
    echo "  Size: ${file_size_mb} MB"
    echo "========================================"
else
    error_exit "Downloaded file not found"
fi