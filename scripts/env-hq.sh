#!/bin/bash

export PATH=${PWD}/fabric-samples/bin:$PATH

export FABRIC_CFG_PATH=${PWD}/fabric-samples/config

export CORE_PEER_TLS_ENABLED=true

export CORE_PEER_LOCALMSPID=HQMSP

export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/hq.coop.local/peers/peer0.hq.coop.local/tls/ca.crt

export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hq.coop.local/users/Admin@hq.coop.local/msp

export CORE_PEER_ADDRESS=peer0.hq.coop.local:7051