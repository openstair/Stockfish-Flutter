#!/bin/bash
set -euo pipefail

# Downloads the two Stockfish NNUE files required by this plugin.
# The files are intentionally not committed to the Git repository.
# Run this script from the package checkout obtained by Flutter Pub.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NNUE_DIR="$SCRIPT_DIR/Sources/stockfish/Stockfish/src/nnue_embedded"

BIG_NAME="nn-c288c895ea92.nnue"
SMALL_NAME="nn-37f18f62d772.nnue"

BIG_URL="https://tests.stockfishchess.org/api/nn/$BIG_NAME"
SMALL_URL="https://tests.stockfishchess.org/api/nn/$SMALL_NAME"

BIG_SHA256="c288c895ea924429ea9092e3f36b2b3c1f00f2a3a4c759ff7e57e79e3b43e4a7"
SMALL_SHA256="37f18f62d772f3107e1d6aaca3898c130c3c86f2ab63e6555fbbca20635a899d"

mkdir -p "$NNUE_DIR"

download_and_verify() {
  local name="$1"
  local url="$2"
  local expected="$3"
  local destination="$NNUE_DIR/$name"
  local temporary="$destination.download"

  if [ -f "$destination" ]; then
    local actual
    actual="$(shasum -a 256 "$destination" | awk '{print $1}')"
    if [ "$actual" = "$expected" ]; then
      echo "✓ $name already exists and is valid."
      return 0
    fi

    echo "⚠ $name exists but failed SHA-256 verification; downloading again."
    rm -f "$destination"
  fi

  echo "Downloading $name..."
  curl --fail --location --retry 3 --retry-delay 2 --progress-bar \
    "$url" -o "$temporary"

  local actual
  actual="$(shasum -a 256 "$temporary" | awk '{print $1}')"

  if [ "$actual" != "$expected" ]; then
    rm -f "$temporary"
    echo "ERROR: SHA-256 mismatch for $name."
    echo "Expected: $expected"
    echo "Actual:   $actual"
    exit 1
  fi

  mv "$temporary" "$destination"
  echo "✓ $name downloaded and verified."
}

download_and_verify "$BIG_NAME" "$BIG_URL" "$BIG_SHA256"
download_and_verify "$SMALL_NAME" "$SMALL_URL" "$SMALL_SHA256"

echo
echo "NNUE setup complete:"
ls -lh "$NNUE_DIR/$BIG_NAME" "$NNUE_DIR/$SMALL_NAME"
