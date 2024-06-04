#!/bin/bash
set -euo pipefail

OPENAPI_SPEC_PATH="https://raw.githubusercontent.com/GetStream/protocol/main/openapi/video-openapi-clientside.yaml"

OUTPUT_DIR="./lib/open_api/video/coordinator"
TEMP_OUTPUT_DIR="./lib/open_api/video/coordinator_temp"

# Clean previous output
rm -rf $TEMP_OUTPUT_DIR
rm -rf $OUTPUT_DIR

# NOTE: https://openapi-generator.tech/docs/generators/dart/
# Generate the Coordinator API models
docker pull openapitools/openapi-generator-cli
docker run --rm \
  -v "${TEMP_OUTPUT_DIR}:/local" openapitools/openapi-generator-cli generate \
  -i "$OPENAPI_SPEC_PATH" \
  -g dart \
  -o /local


# Copy the generated code to the correct location
cp -r $TEMP_OUTPUT_DIR/lib $OUTPUT_DIR

# Write the API version to a file
README_FILE="$TEMP_OUTPUT_DIR/README.md"
API_VERSION=$(grep -i "API version" "$README_FILE" | awk -F ': ' '{print $2}')
OUTPUT_FILE="$OUTPUT_DIR/.api_version"
echo "$API_VERSION" > "$OUTPUT_FILE"

# Remove the generated API client, just keep the models
rm -rf $TEMP_OUTPUT_DIR
