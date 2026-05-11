#!/bin/bash

set -e

export PATH=${PWD}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

CHANNEL_NAME=mainchannel

ORDERER_CA=${PWD}/organizations/ordererOrganizations/orderer.coop.local/orderers/orderer0.orderer.coop.local/msp/tlscacerts/tlsca.orderer.coop.local-cert.pem

echo "Generating anchor peer update for HQ..."

configtxgen \
  -profile CoopChannel \
  -outputAnchorPeersUpdate ./channel-artifacts/HQMSPanchors.tx \
  -channelID ${CHANNEL_NAME} \
  -asOrg HQMSP

echo "Generating anchor peer update for Branch..."

configtxgen \
  -profile CoopChannel \
  -outputAnchorPeersUpdate ./channel-artifacts/BranchMSPanchors.tx \
  -channelID ${CHANNEL_NAME} \
  -asOrg BranchMSP

echo "Updating HQ anchor peer..."

source ./scripts/env-hq.sh

peer channel update \
  -o localhost:7050 \
  --ordererTLSHostnameOverride orderer0.orderer.coop.local \
  -c ${CHANNEL_NAME} \
  -f ./channel-artifacts/HQMSPanchors.tx \
  --tls \
  --cafile ${ORDERER_CA}

echo "Updating Branch anchor peer..."

source ./scripts/env-branch.sh

peer channel update \
  -o localhost:7050 \
  --ordererTLSHostnameOverride orderer0.orderer.coop.local \
  -c ${CHANNEL_NAME} \
  -f ./channel-artifacts/BranchMSPanchors.tx \
  --tls \
  --cafile ${ORDERER_CA}

echo "Anchor peers updated."