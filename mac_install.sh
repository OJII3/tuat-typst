#!/bin/sh

# Define the path to the directory where the script is located

DATA_DIR="$HOME/Library/Caches"

NAMESPACE="local"
NAME="tuat-typst"
VERSION="0.1.0"

FULL_PATH="$DATA_DIR/typst/packages/$NAMESPACE/$NAME/$VERSION"
TEMP_DIR="/tmp/$NAME/" # /tmp is cleared on reboot so it's safe to use

# Check if git is installed
if ! command -v git > /dev/null; then
    echo "Error: git is not installed"
    exit 1
fi

# Create temp directory to clone the repository
[ -d "$TEMP_DIR" ] &&  rm -rf "$TEMP_DIR"
git clone --depth 1 https://github.com/ojii3/tuat-typst.git "$TEMP_DIR"

# Create the destination directory 
[ -d "$FULL_PATH" ] || mkdir -p "$FULL_PATH"

# Copy the files to the destination directory
[ -d "$FULL_PATH" ] && rm -rf "$FULL_PATH"
cp -r "$TEMP_DIR" "$FULL_PATH"

# Clean up
rm -rf "$TEMP_DIR"

echo "========================================"
echo "$(tput setaf 2)Installation completed successfully$(tput sgr0)"

