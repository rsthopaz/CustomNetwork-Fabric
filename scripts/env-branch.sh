#!/bin/bash

export PATH=${PWD}/fabric-samples/bin:$PATH

export FABRIC_CFG_PATH=${PWD}/fabric-samples/config

export CORE_PEER_TLS_ENABLED=true

export CORE_PEER_LOCALMSPID=BranchMSP

export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/branch.coop.local/peers/peer0.branch.coop.local/tls/ca.crt

export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/branch.coop.local/users/Admin@branch.coop.local/msp

export CORE_PEER_ADDRESS=peer0.branch.coop.local:9051

export ORDERER_CA=${PWD}/organizations/ordererOrganizations/orderer.coop.local/tlsca/tlsca.orderer.coop.local-cert.pem

export PEER0_HQ_CA=${PWD}/organizations/peerOrganizations/hq.coop.local/peers/peer0.hq.coop.local/tls/ca.crt

export PEER0_BRANCH_CA=${PWD}/organizations/peerOrganizations/branch.coop.local/peers/peer0.branch.coop.local/tls/ca.crt