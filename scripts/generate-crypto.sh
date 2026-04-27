#!/bin/bash

set -e

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)

CRYPTO_CONFIG="${ROOT_DIR}/config/crypto-config.yaml"
OUTPUT_DIR="${ROOT_DIR}/organizations"

echo "Generating certificates..."

rm -rf "${OUTPUT_DIR}"

cryptogen generate \
  --config="${CRYPTO_CONFIG}" \
  --output="${OUTPUT_DIR}"

echo "Done."