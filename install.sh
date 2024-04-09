#!/bin/sh

# Define the path to the directory where the script is located

DATA_DIR="$XDG_DATA_HOME"
[ -z "$DATA_DIR" ] && DATA_DIR="$HOME/.local/share"

NAMESPACE="local"
NAME="tuat-typst"
VERSION="0.1.0"

FULL_PATH="$DATA_DIR/typst/packages/$NAMESPACE/$NAME/$VERSION"
TEMP_DIR="/tmp/$NAME/"

# Create temp directory to clone the repository
[ -d "$TEMP_DIR" ] &&  rm -rf "$TEMP_DIR"
git clone --depth 1 https://github.com/ojii3/tuat-typst.git "$TEMP_DIR"

# Create the destination directory
[ -d "$FULL_PATH" ] || mkdir -p "$FULL_PATH"

# Copy the files to the destination directory
[ -d "$FULL_PATH" ] && rm -rf "$FULL_PATH"
cp -r "$TEMP_DIR" "$FULL_PATH"
