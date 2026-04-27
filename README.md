# 0. First: Translate Cooperative Business Into Fabric Topology

Your cooperative is not "one company with blockchain."

It's more like:

Consortium blockchain:

Organization A → Headquarters Cooperative
Organization B → Branch Cooperative 1
Organization C → Branch Cooperative 2 (future expansion)
Auditor Org (optional later)
Regulator Org (optional read-only later)

This maps naturally into Fabric's organization model.

Recommended initial architecture:

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

Later:

+ orderer1
+ orderer2
+ AuditorOrg
+ BranchOrg2
+ BranchOrg3

Scale horizontally.

# 1) Components You Need To Create

Fabric network = several layers.

A. PKI / Identity Layer

This is trust.

Without this, Fabric doesn't run.

Components:

Root CA

Issues certificates.

Certificates identify:

admins
peers
orderers
clients
users

Example:

HQ Admin cert
HQ peer0 cert
HQ peer1 cert

Branch Admin cert
Branch peer0 cert
Branch peer1 cert

Orderer cert

With Cryptogen:

generated statically
easy
dev friendly
not production ideal

With Fabric CA:

dynamic enrollment
revoke certs
rotate certs
register users
production approach
MSP (Membership Service Provider)

Identity bundle.

Contains:

cacerts/
admincerts/
keystore/
signcerts/
config.yaml

MSP defines:

"Who belongs to organization X?"

Every org has MSP.

Example:

HQMSP
BranchMSP
OrdererMSP
B. Network Nodes
Peer

Stores ledger + executes chaincode.

Functions:

endorse transactions
validate blocks
commit blocks
gossip

Minimum:

2 org × 1 peer = 2 peers

Recommended:

2 org × 2 peers = 4 peers

Why?

For:

HA
gossip redundancy
future scaling
org internal resilience

Example:

peer0.hq.coop
peer1.hq.coop

peer0.branch.coop
peer1.branch.coop
CouchDB

Optional but strongly recommended.

Alternative:

LevelDB (embedded)

Use CouchDB because:

JSON query support
rich query
Mango selector
reporting easier

For cooperative:

memberships / loans / savings / approvals → JSON objects

CouchDB ideal.

Each peer usually gets:

1 peer : 1 couchdb

Example:

peer0 + couch0
peer1 + couch1
Orderer

Creates blocks.

Does NOT execute smart contracts.

Role:

collect tx
→ order
→ package block
→ distribute block

Consensus:

Raft.

Start:

1 node:

orderer0

Production:

3 nodes:

orderer0
orderer1
orderer2

Why 3?

Raft majority:

2/3 quorum.

1 failure tolerated.

C. Channel Layer

Logical private ledger.

Think:

sub-network.

Possible cooperative design:

Option A (simple)

One channel:

coopchannel

Everything there.

Easy.

Recommended first build.

Option B (better)

Separate channels:

governance-channel
finance-channel
audit-channel

Pros:

privacy segmentation.

Cons:

more ops complexity.

My recommendation:

Start:

1 channel

Later:

2 channels

mainchannel
auditchannel
D. Chaincode Lifecycle Layer

Need infra for:

package
install
approve
commit

Chaincode examples:

member contract
loan contract
saving contract
voting contract

Not your focus yet—but network must support lifecycle.

E. Ops Layer

Monitoring:

logs
metrics
backup
certificate renewal

Later:

Prometheus
Grafana

# 2) Work Order (Step-by-Step Planning)

Not commands—architecture order.

Phase 1 — Define Consortium

Decide:

Org names
domains
MSP names
peer counts
channel count
orderer count

Example:

HQOrg → HQMSP
BranchOrg → BranchMSP
OrdererOrg → OrdererMSP
Phase 2 — PKI Design

Create:

CA hierarchy.

With Cryptogen:

generate:

org certs
peer certs
admin certs
tls certs

Output:

crypto-config equivalent.

Equivalent in sample network:

organizations/

inside fabric-samples.

Phase 3 — Genesis Block

Build consortium definition.

Defines:

orderer
consortium members
policies

Equivalent test-network:

configtx/configtx.yaml

You will create your own.

Phase 4 — Docker Topology

Create:

containers:

peer
orderer
couchdb
cli(optional)

Equivalent test-network:

docker/docker-compose-test-net.yaml

You create:

docker-compose-network.yaml

custom.

Phase 5 — Start Ordering Service

Bring up:

orderer first.

Check:

TLS + MSP valid.

Phase 6 — Start Peers

Bring:

HQ peers.

Bring:

Branch peers.

Join gossip.

Join network.

Phase 7 — Create Channel

Create:

mainchannel.

Peers join.

Anchor peers set.

Equivalent sample:

createChannel.sh.

You'll automate yourself.

Phase 8 — Lifecycle Validation

Deploy dummy chaincode:

ping contract.

Verify:

endorsement → commit.

Phase 9 — Monitoring / Backup

Snapshots.

Volumes.

Recovery.

# 3) Recommended Folder Structure

Recommended:

coop-fabric-network/
│
├── crypto/
│   ├── cryptogen/
│   └── fabric-ca/            (future)
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
│   └── compose-ca.yaml        (future)
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

This is production-like.

# 4) Key Design Decisions + Rationale
Peers

Minimum:

2 total.

Recommended:

4 total.

Reason:

HA.

Orderers

Minimum:

Ideal:

Reason:

Raft quorum.

Channels

Minimum:

Ideal:

2–3.

Reason:

privacy segmentation.

Database

Use:

CouchDB

Reason:

cooperative data = document-heavy.

Certificate Authority

Start:

Cryptogen.

Later:

Hyperledger Fabric CA

Reason:

identity lifecycle.

# 5) Simple vs Ideal
Simple MVP
2 org
1 peer each
1 orderer
1 channel
Cryptogen
Docker Compose

Very manageable.

Better Dev
2 org
2 peers each
1 orderer
1 channel
CouchDB
Cryptogen

Best starting point.

Production-ish
2+ org
2 peers/org
3 orderers
2 channels
Fabric CA
monitoring
backup
Kubernetes

Ideal target.

# 6) Common Mistakes
1. MSP naming inconsistency

Example:

HQMSP

vs config says:

HeadquarterMSP

Breaks signatures.

Very common.

2. TLS cert wrong hostname

Fabric is strict.

CN/SAN mismatch → fail.

3. Wrong volume mounts

Ledger disappears on restart.

Need persistent volumes.

4. One peer only

Single point failure.

5. No anchor peer config

Cross-org gossip fails.

6. Overcomplicated channels early

Start one channel.

7. Using test-network as base code

Bad habit.

Use as:

reference only.

Learn from:

network.sh
compose files
configtx
organizations/
scripts/

Then rewrite cleanly.

Mapping to fabric-samples test-network

Reference mapping:

fabric-samples/test-network
│
├── organizations/        -> your organizations/
├── compose/              -> your docker/
├── scripts/              -> your scripts/
├── configtx/             -> your config/
└── channel-artifacts/    -> your channel-artifacts/

Keep concept.