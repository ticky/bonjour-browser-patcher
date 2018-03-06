#!/bin/bash
set -euo pipefail

TITLE="Bonjour Browser Patcher"
OUTPUT_APP_NAME="$(dirname $0)/Applications/$TITLE.app"

echo "Building $TITLE in $OUTPUT_APP_NAME..."

mkdir -p "$(dirname $0)/Applications"

echo "Compiling script to app bundle..."

osacompile \
  -o "$OUTPUT_APP_NAME" \
  -x \
  "$TITLE.applescript"

echo "Adding current version of the patch..."

cp \
  "bonjour-browser.patch" \
  "$OUTPUT_APP_NAME/Contents/Resources"

echo "Done!"
