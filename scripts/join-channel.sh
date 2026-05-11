#!/bin/bash

set -e

CHANNEL_NAME=mainchannel

echo "Joining HQ peer..."

source ./scripts/env-hq.sh

peer channel join \
  -b ./channel-artifacts/${CHANNEL_NAME}.block

echo "Joining Branch peer..."

source ./scripts/env-branch.sh

peer channel join \
  -b ./channel-artifacts/${CHANNEL_NAME}.block

echo "Peers joined channel."