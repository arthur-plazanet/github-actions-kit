#!/bin/bash

# process_url.sh
# Usage: ./process_url.sh "<URL>"

set -euo pipefail

# Input URL
APP_NAME_INPUT="$1"

# Default protocol to prepend if missing
DEFAULT_PROTOCOL="https://"

# Supported protocols
SUPPORTED_PROTOCOLS=("http://" "https://" "ftp://" "ssh://" "git@")

# Function to validate URL format
validate_url() {
  local url="$1"
  # Simple regex for URL validation
  if [[ "$url" =~ ^([a-zA-Z][a-zA-Z0-9+\-.]*://)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:[0-9]+)?(/.*)?$ ]]; then
    return 0
  else
    return 1
  fi
}

# Validate the input URL
if validate_url "$APP_NAME_INPUT"; then
  echo "Input URL is valid."
else
  echo "Error: Invalid URL format for app_name: '$APP_NAME_INPUT'"
  exit 1
fi

# Check if APP_NAME_INPUT starts with a supported protocol
PROTOCOL_FOUND=false
for protocol in "${SUPPORTED_PROTOCOLS[@]}"; do
  if [[ "$APP_NAME_INPUT" == "$protocol"* ]]; then
    PROTOCOL_APP_NAME="$APP_NAME_INPUT"
    PROTOCOL_FOUND=true
    echo "Detected protocol '$protocol' in app_name."
    break
  fi
done

if [ "$PROTOCOL_FOUND" = false ]; then
  # Prepend default protocol if none found
  PROTOCOL_APP_NAME="${DEFAULT_PROTOCOL}${APP_NAME_INPUT}"
  echo "No supported protocol found. Prepending '${DEFAULT_PROTOCOL}'."
fi

# Prepare APP_NAME_NO_PROTOCOL by removing the protocol
# Handle protocols with '://'
if [[ "$PROTOCOL_APP_NAME" == *"://"* ]]; then
  APP_NAME_NO_PROTOCOL="${PROTOCOL_APP_NAME#*://}"
else
  # Handle protocols like 'git@' which don't use '://'
  APP_NAME_NO_PROTOCOL="${PROTOCOL_APP_NAME#git@}"
fi

# Export the variables to GitHub Actions
echo "APP_NAME_WITH_PROTOCOL=$PROTOCOL_APP_NAME" >>"$GITHUB_OUTPUT"
echo "APP_NAME_NO_PROTOCOL=$APP_NAME_NO_PROTOCOL" >>"$GITHUB_OUTPUT"
