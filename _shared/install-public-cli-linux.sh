#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "" || "${2:-}" == "" || "${3:-}" == "" ]]; then
  cat <<'USAGE'
Usage:
  ./install-public-cli-linux.sh <owner/repo> <asset_name> <binary_name> [install_dir]

Example:
  ./install-public-cli-linux.sh sharkdp/bat bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz bat "$HOME/.local/bin"
USAGE
  exit 1
fi

REPO="$1"
ASSET_NAME="$2"
BINARY_NAME="$3"
INSTALL_DIR="${4:-$HOME/.local/bin}"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

require_cmd curl
require_cmd tar

if [[ "$ASSET_NAME" == *.zip ]]; then
  require_cmd unzip
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

API_URL="https://api.github.com/repos/${REPO}/releases/latest"
echo "Fetching latest release metadata: $API_URL"
RELEASE_JSON="$(curl -fsSL "$API_URL")"

ASSET_URL="$(printf '%s' "$RELEASE_JSON" | awk -v asset="$ASSET_NAME" -F'"' '$2=="browser_download_url" && $4 ~ ("/" asset "$") { print $4; exit }')"
if [[ -z "$ASSET_URL" ]]; then
  echo "Could not find asset '$ASSET_NAME' in latest release of '$REPO'." >&2
  exit 1
fi

ARCHIVE_PATH="$TMP_DIR/$ASSET_NAME"
echo "Downloading: $ASSET_URL"
curl -fL "$ASSET_URL" -o "$ARCHIVE_PATH"

EXTRACT_DIR="$TMP_DIR/extract"
mkdir -p "$EXTRACT_DIR"

case "$ASSET_NAME" in
  *.tar.gz|*.tgz) tar -xzf "$ARCHIVE_PATH" -C "$EXTRACT_DIR" ;;
  *.tar.xz) tar -xJf "$ARCHIVE_PATH" -C "$EXTRACT_DIR" ;;
  *.tar.bz2) tar -xjf "$ARCHIVE_PATH" -C "$EXTRACT_DIR" ;;
  *.zip) unzip -q "$ARCHIVE_PATH" -d "$EXTRACT_DIR" ;;
  *)
    cp "$ARCHIVE_PATH" "$EXTRACT_DIR/$BINARY_NAME"
    ;;
esac

BIN_CANDIDATE="$(find "$EXTRACT_DIR" -type f -name "$BINARY_NAME" -print -quit || true)"
if [[ -z "$BIN_CANDIDATE" ]]; then
  echo "Binary '$BINARY_NAME' not found after extracting '$ASSET_NAME'." >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"
install -m 755 "$BIN_CANDIDATE" "$INSTALL_DIR/$BINARY_NAME"

echo "Installed '$BINARY_NAME' to '$INSTALL_DIR/$BINARY_NAME'"
echo "If needed, add to PATH:"
echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
