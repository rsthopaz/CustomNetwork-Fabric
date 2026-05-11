#!/bin/bash

set -e

echo "Starting CouchDB services..."

docker compose \
  -f docker/docker-compose-couchdb.yaml \
  up -d

echo "Starting Orderer service..."

docker compose \
  -f docker/docker-compose-orderer.yaml \
  up -d

echo "Starting Peer services..."

docker compose \
  -f docker/docker-compose-couchdb.yaml \
  -f docker/docker-compose-peers.yaml \
  up -d

echo "Network started."