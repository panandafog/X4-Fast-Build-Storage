#!/usr/bin/env bash
# Builds a clean X4 extension archive for manual installation on macOS or Linux.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MOD_NAME="fast_build_storage"
VERSION=$(sed -n '/^[[:space:]]*version="/ { s/.*version="\([^"]*\)".*/\1/; p; q; }' "$SCRIPT_DIR/content.xml")

if [[ -z "$VERSION" ]]; then
  printf '%s\n' "Could not read the mod version from content.xml." >&2
  exit 1
fi

STAGING_DIR=$(mktemp -d "${TMPDIR:-/tmp}/fast-build-storage.XXXXXX")
ARCHIVE_DIR="$SCRIPT_DIR/dist"
ARCHIVE_PATH="$ARCHIVE_DIR/${MOD_NAME}_v${VERSION}.zip"

cleanup() {
  rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

mkdir -p "$STAGING_DIR/$MOD_NAME/md" "$ARCHIVE_DIR"
cp "$SCRIPT_DIR/content.xml" "$STAGING_DIR/$MOD_NAME/"
cp "$SCRIPT_DIR/md/FastBuildStorage.xml" "$STAGING_DIR/$MOD_NAME/md/"

rm -f "$ARCHIVE_PATH"
(
  cd "$STAGING_DIR"
  zip -qr "$ARCHIVE_PATH" "$MOD_NAME"
)

printf 'Created: %s\n' "$ARCHIVE_PATH"
printf '%s\n' "Archive contents:"
unzip -l "$ARCHIVE_PATH"
