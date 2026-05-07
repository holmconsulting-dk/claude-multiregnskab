#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${CLAUDE_PLUGIN_ROOT}/bin"
TARGET="${BIN_DIR}/mr"
REPO="holmconsulting-dk/cli-multiregnskab"
VERSION="v1.0.0"
EXPECTED="${VERSION#v}"  # strip leading 'v' — mr --version outputs e.g. "0.0.3-test"

NEEDS_DOWNLOAD=true

if [ -x "$TARGET" ]; then
  INSTALLED=$("$TARGET" --version 2>/dev/null || echo "")
  if [ "$INSTALLED" = "$EXPECTED" ]; then
    NEEDS_DOWNLOAD=false
  else
    echo "multiregnskab: version mismatch (installed: ${INSTALLED:-unknown}, expected: ${EXPECTED}), updating..."
  fi
fi

if [ "$NEEDS_DOWNLOAD" = true ]; then
  OS=$(uname -s)
  ARCH=$(uname -m)

  case "$OS" in
    Darwin) PLATFORM="macos" ;;
    Linux)  PLATFORM="linux" ;;
    *)
      echo "multiregnskab: unsupported OS: $OS" >&2
      exit 1
      ;;
  esac

  case "$ARCH" in
    arm64|aarch64) ARCH_SUFFIX="arm64" ;;
    x86_64|amd64)  ARCH_SUFFIX="x64"   ;;
    *)
      echo "multiregnskab: unsupported architecture: $ARCH" >&2
      exit 1
      ;;
  esac

  PATTERN="mr-${PLATFORM}-${ARCH_SUFFIX}"

  mkdir -p "$BIN_DIR"

  URL="https://github.com/${REPO}/releases/download/${VERSION}/${PATTERN}"
  echo "multiregnskab: downloading ${PATTERN} from ${URL}..."
  curl -fsSL "$URL" -o "$TARGET"

  chmod +x "$TARGET"
  echo "multiregnskab: mr ${EXPECTED} installed at ${TARGET}"
fi

if ! "$TARGET" user show > /dev/null 2>&1; then
  echo ""
  echo "multiregnskab: NOT logged in to multiregnskab.dk."
  echo "   Open a new terminal window and run: mr user login"
  echo "   Then return to this session and you are ready to go."
  echo ""
fi
