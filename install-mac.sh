#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSET_NAME="${1:?Usage: ./install-mac.sh <asset_name> <binary_name> [install_dir]}"
BINARY_NAME="${2:?Usage: ./install-mac.sh <asset_name> <binary_name> [install_dir]}"
INSTALL_DIR="${3:-$HOME/.local/bin}"
exec "$SCRIPT_DIR/./_shared/install-public-cli-macos.sh" "billydeeii136/black-opps-ruflo-50-ai-agent" "$ASSET_NAME" "$BINARY_NAME" "$INSTALL_DIR"
