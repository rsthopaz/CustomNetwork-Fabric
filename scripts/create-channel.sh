#!/bin/bash

set -e

export PATH=${PWD}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

CHANNEL_NAME=mainchannel

ORDERER_CA=${PWD}/organizations/ordererOrganizations/orderer.coop.local/orderers/orderer0.orderer.coop.local/msp/tlscacerts/tlsca.orderer.coop.local-cert.pem

echo "Creating channel..."

peer channel create \
  -o localhost:7050 \
  --ordererTLSHostnameOverride orderer0.orderer.coop.local \
  -c ${CHANNEL_NAME} \
  -f ./channel-artifacts/mainchannel.tx \
  --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
  --tls \
  --cafile ${ORDERER_CA}

echo "Channel created."