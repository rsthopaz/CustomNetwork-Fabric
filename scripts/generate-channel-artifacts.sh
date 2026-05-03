#!/bin/bash

set -e

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)

export FABRIC_CFG_PATH="${ROOT_DIR}/config"

ARTIFACT_DIR="${ROOT_DIR}/channel-artifacts"

mkdir -p "${ARTIFACT_DIR}"

echo "Cleaning old artifacts..."
rm -f "${ARTIFACT_DIR}"/*

echo "Generating orderer genesis block..."

configtxgen \
  -profile CoopGenesis \
  -channelID system-channel \
  -outputBlock "${ARTIFACT_DIR}/genesis.block"

echo "Generating channel creation transaction..."

configtxgen \
  -profile CoopChannel \
  -channelID mainchannel \
  -outputCreateChannelTx "${ARTIFACT_DIR}/mainchannel.tx"

echo "Done."