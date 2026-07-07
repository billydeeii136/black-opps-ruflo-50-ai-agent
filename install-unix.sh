#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSET_NAME="${1:?Usage: ./install-unix.sh <asset_name> <binary_name> [install_dir]}"
BINARY_NAME="${2:?Usage: ./install-unix.sh <asset_name> <binary_name> [install_dir]}"
INSTALL_DIR="${3:-$HOME/.local/bin}"
OS_NAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS_NAME" in
  darwin*) exec "$SCRIPT_DIR/install-mac.sh" "$ASSET_NAME" "$BINARY_NAME" "$INSTALL_DIR" ;;
  linux*) exec "$SCRIPT_DIR/install-linux.sh" "$ASSET_NAME" "$BINARY_NAME" "$INSTALL_DIR" ;;
  *)
    echo "Unsupported Unix OS: $OS_NAME" >&2
    echo "Use install-mac.sh, install-linux.sh, or install-lynx.sh directly." >&2
    exit 1
    ;;
esac
