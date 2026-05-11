#!/bin/bash

set -e

echo "Stopping Peer services..."

docker compose \
  -f docker/docker-compose-couchdb.yaml \
  -f docker/docker-compose-peers.yaml \
  down

echo "Stopping Orderer service..."

docker compose \
  -f docker/docker-compose-orderer.yaml \
  down

echo "Stopping CouchDB services..."

docker compose \
  -f docker/docker-compose-couchdb.yaml \
  down

echo "Network stopped."