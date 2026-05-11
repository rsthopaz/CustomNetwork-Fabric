# Hyperledger Fabric Cooperative Network Architecture

## Overview

This project defines a production-oriented Hyperledger Fabric topology for a cooperative organization network.

The architecture models the cooperative as a consortium blockchain rather than a single organization using blockchain internally.

---

# 0. Cooperative Topology → Fabric Consortium Model

The cooperative structure maps naturally into Hyperledger Fabric organizations.

## Consortium: `CoopNet`

```text
Consortium: CoopNet

Members:
├── HQ Org
│   ├── peer0
│   └── peer1
│
├── Branch Org
│   ├── peer0
│   └── peer1
│
└── Ordering Service
    └── orderer0
```

## Future Expansion

```text
+ orderer1
+ orderer2
+ AuditorOrg
+ BranchOrg2
+ BranchOrg3
```

The architecture is designed for horizontal scaling.

---

# 1. Core Components

Fabric networks consist of multiple infrastructure layers.

---

## A. PKI / Identity Layer

The identity layer provides trust and authentication.

Without PKI, Fabric cannot operate.

### Components

* Root CA
* Organization certificates
* Peer certificates
* Orderer certificates
* Client certificates
* User certificates

### Example Certificates

```text
HQ Admin cert
HQ peer0 cert
HQ peer1 cert

Branch Admin cert
Branch peer0 cert
Branch peer1 cert

Orderer cert
```

---

### Cryptogen (Development)

Advantages:

* Static certificate generation
* Easy setup
* Development friendly

Limitations:

* Not ideal for production

---

### Fabric CA (Production)

Advantages:

* Dynamic enrollment
* Certificate revocation
* Certificate rotation
* User registration
* Full identity lifecycle management

Recommended for production deployments.

---

## MSP (Membership Service Provider)

The MSP defines organizational identity boundaries.

Example MSPs:

```text
HQMSP
BranchMSP
OrdererMSP
```

Typical MSP structure:

```text
cacerts/
admincerts/
keystore/
signcerts/
config.yaml
```

MSPs answer the question:

> "Who belongs to organization X?"

---

## B. Network Nodes

### Peer Nodes

Peers:

* Store ledgers
* Execute chaincode
* Endorse transactions
* Validate blocks
* Commit blocks
* Participate in gossip

### Minimum Topology

```text
2 organizations × 1 peer = 2 peers
```

### Recommended Topology

```text
2 organizations × 2 peers = 4 peers
```

Benefits:

* High availability
* Gossip redundancy
* Internal resilience
* Better scalability

### Example Hostnames

```text
peer0.hq.coop
peer1.hq.coop

peer0.branch.coop
peer1.branch.coop
```

---

## CouchDB

### Recommended Database

Fabric supports:

* LevelDB (embedded)
* CouchDB

Use CouchDB for cooperative workloads because it supports:

* JSON documents
* Rich queries
* Mango selectors
* Easier reporting

Ideal for:

* Memberships
* Loans
* Savings
* Governance approvals

### Recommended Mapping

```text
1 peer : 1 CouchDB
```

Example:

```text
peer0 + couch0
peer1 + couch1
```

---

## Orderer Nodes

Orderers:

* Collect transactions
* Order transactions
* Package blocks
* Distribute blocks

Orderers do **not** execute chaincode.

### Consensus

Use:

```text
Raft
```

### Initial Deployment

```text
orderer0
```

### Production Deployment

```text
orderer0
orderer1
orderer2
```

### Why 3 Orderers?

Raft requires majority quorum:

```text
2 / 3 quorum
```

This tolerates one node failure.

---

# 2. Channel Layer

Channels are logical private ledgers.

Think of them as isolated sub-networks.

---

## Option A — Simple

Single channel:

```text
coopchannel
```

Recommended for the initial build.

Advantages:

* Easier operations
* Simpler deployment
* Faster development

---

## Option B — Segmented

Multiple channels:

```text
governance-channel
finance-channel
audit-channel
```

Advantages:

* Better privacy separation

Disadvantages:

* Increased operational complexity

---

## Recommended Approach

### Start With

```text
mainchannel
```

### Expand Later

```text
mainchannel
auditchannel
```

---

# 3. Chaincode Lifecycle Layer

The network must support chaincode lifecycle operations:

* Package
* Install
* Approve
* Commit

---

## Example Chaincodes

* Member contract
* Loan contract
* Savings contract
* Voting contract

---

# 4. Operations Layer

Operational infrastructure should include:

* Logging
* Metrics
* Backups
* Certificate renewal

Future additions:

* Prometheus
* Grafana

---

# 5. Deployment Plan

---

## Phase 1 — Define Consortium

Decide:

* Organization names
* Domains
* MSP names
* Peer counts
* Channel counts
* Orderer counts

Example:

```text
HQOrg       → HQMSP
BranchOrg   → BranchMSP
OrdererOrg  → OrdererMSP
```

---

## Phase 2 — PKI Design

Generate:

* Organization certificates
* Peer certificates
* Admin certificates
* TLS certificates

Equivalent directory:

```text
organizations/
```

---

## Phase 3 — Genesis Block

Create the consortium definition.

Defines:

* Orderers
* Consortium members
* Policies

Equivalent file:

```text
configtx/configtx.yaml
```

---

## Phase 4 — Docker Topology

Create Docker containers for:

* Peers
* Orderers
* CouchDB
* CLI tools (optional)

Example compose file:

```text
docker-compose-network.yaml
```

---

## Phase 5 — Start Ordering Service

Bring up orderers first.

Validate:

* TLS configuration
* MSP configuration

---

## Phase 6 — Start Peers

Bring up:

* HQ peers
* Branch peers

Then:

* Join gossip network
* Join consortium

---

## Phase 7 — Create Channel

Create:

```text
mainchannel
```

Then:

* Join peers
* Configure anchor peers

---

## Phase 8 — Validate Lifecycle

Deploy a simple test chaincode.

Example:

```text
ping-contract
```

Verify:

```text
endorsement → commit
```

---

## Phase 9 — Monitoring & Backup

Implement:

* Snapshots
* Persistent volumes
* Recovery procedures

---

# 6. Recommended Project Structure

```text
coop-fabric-network/
│
├── crypto/
│   ├── cryptogen/
│   └── fabric-ca/
│
├── config/
│   ├── crypto-config.yaml
│   ├── configtx.yaml
│   └── core.yaml
│
├── organizations/
│   ├── peerOrganizations/
│   └── ordererOrganizations/
│
├── channel-artifacts/
│   ├── genesis.block
│   ├── mainchannel.tx
│   └── anchors/
│
├── docker/
│   ├── compose-orderer.yaml
│   ├── compose-peers.yaml
│   ├── compose-couchdb.yaml
│   └── compose-ca.yaml
│
├── scripts/
│   ├── generate-crypto.sh
│   ├── create-channel.sh
│   ├── join-channel.sh
│   └── deploy-chaincode.sh
│
├── env/
│   ├── hq.env
│   ├── branch.env
│   └── orderer.env
│
├── volumes/
│
└── README.md
```

---

# 7. Design Recommendations

## Peers

### Minimum

```text
2 total peers
```

### Recommended

```text
4 total peers
```

Reason:

* High availability
* Resilience

---

## Orderers

### Minimum

```text
1 orderer
```

### Recommended

```text
3 orderers
```

Reason:

* Raft quorum
* Fault tolerance

---

## Channels

### Minimum

```text
1 channel
```

### Recommended

```text
2–3 channels
```

Reason:

* Privacy segmentation

---

## Database

Use:

```text
CouchDB
```

Reason:

* Cooperative workloads are document-heavy

---

## Certificate Authority

### Start With

```text
Cryptogen
```

### Upgrade To

```text
Hyperledger Fabric CA
```

Reason:

* Full identity lifecycle management

---

# 8. Deployment Profiles

## Simple MVP

```text
2 orgs
1 peer each
1 orderer
1 channel
Cryptogen
Docker Compose
```

---

## Recommended Development Setup

```text
2 orgs
2 peers each
1 orderer
1 channel
CouchDB
Cryptogen
```

---

## Production-Oriented Setup

```text
2+ orgs
2 peers per org
3 orderers
2 channels
Fabric CA
Monitoring
Backups
Kubernetes
```

---

# 9. Common Mistakes

---

## 1. MSP Naming Inconsistency

Example:

```text
HQMSP
```

vs

```text
HeadquarterMSP
```

This breaks signatures and validation.

---

## 2. TLS Hostname Mismatch

Fabric strictly validates:

* CN
* SAN

Incorrect hostnames will fail connections.

---

## 3. Incorrect Volume Mounts

Without persistent volumes:

* Ledger data disappears after restart

---

## 4. Single Peer Deployment

A single peer creates a single point of failure.

---

## 5. Missing Anchor Peer Configuration

Without anchor peers:

* Cross-organization gossip fails

---

## 6. Overcomplicated Channel Design

Start simple.

Recommended:

```text
1 channel initially
```

---

## 7. Using `test-network` as Production Base

Do not copy `fabric-samples/test-network` directly into production.

Use it only as a reference for:

* `network.sh`
* Compose files
* `configtx`
* Organizations
* Scripts

Rewrite cleanly for your own deployment.

---

# 10. Mapping to `fabric-samples/test-network`

```text
fabric-samples/test-network
│
├── organizations/      → your organizations/
├── compose/            → your docker/
├── scripts/            → your scripts/
├── configtx/           → your config/
└── channel-artifacts/  → your channel-artifacts/
```

Keep the concepts, not the implementation.
