#!/bin/sh
set -eu

VERSION="0.2.0"
NAME="tuat-typst"
NAMESPACE="local"

case "$(uname -s)" in
  Darwin)
    DATA_DIR="$HOME/Library/Application Support"
    ;;
  *)
    DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
    ;;
esac

PACKAGE_DIR="$DATA_DIR/typst/packages/$NAMESPACE/$NAME"
TARGET="$PACKAGE_DIR/$VERSION"
TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/$NAME.XXXXXX")"
STAGING=""
BACKUP=""

cleanup() {
  if [ -n "$STAGING" ] && [ -d "$STAGING" ]; then
    rm -rf "$STAGING"
  fi
  if [ -n "$BACKUP" ] && [ -d "$BACKUP" ] && [ ! -e "$TARGET" ]; then
    mv "$BACKUP" "$TARGET"
  fi
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

mkdir -p "$PACKAGE_DIR"
STAGING="$(mktemp -d "$PACKAGE_DIR/.$VERSION.staging.XXXXXX")"
ARCHIVE="$TEMP_DIR/package.tar.gz"
curl --fail --location --silent --show-error \
  "https://github.com/OJII3/tuat-typst/archive/refs/tags/v$VERSION.tar.gz" \
  --output "$ARCHIVE"
tar -xzf "$ARCHIVE" --strip-components=1 -C "$STAGING"

if [ ! -f "$STAGING/typst.toml" ] || ! grep -Fq "version = \"$VERSION\"" "$STAGING/typst.toml"; then
  echo "Downloaded package is missing or has a mismatched typst.toml" >&2
  exit 1
fi

if [ -e "$TARGET" ]; then
  BACKUP="$(mktemp -d "$PACKAGE_DIR/.$VERSION.backup.XXXXXX")"
  rmdir "$BACKUP"
  mv "$TARGET" "$BACKUP"
fi
mv "$STAGING" "$TARGET"
STAGING=""
if [ -n "$BACKUP" ]; then
  rm -rf "$BACKUP"
  BACKUP=""
fi

echo "Installed @$NAMESPACE/$NAME:$VERSION"
