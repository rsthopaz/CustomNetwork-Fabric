# STEP 2 — Define Network Blueprint (config/network.yaml)

This is now the source-of-truth for your cooperative network.

Everything later derives from here:

cryptogen config
MSP naming
domains
peer hostnames
orderer hostname
channel definitions
Docker service naming

1. Purpose in Cooperative Architecture

We now formalize:

Business:

Headquarters Cooperative
Branch Cooperative
Ordering Service

Technical mapping:

HQMSP
BranchMSP
OrdererMSP

Infrastructure mapping:

peer0.hq.coop.local
peer1.hq.coop.local

peer0.branch.coop.local
peer1.branch.coop.local

orderer0.coop.local

Channel:

mainchannel

Consortium:

CoopConsortium

This file becomes:

architecture contract

2. File Structure

Already exists:

config/
└── network.yaml

Only this file for Step 2.

No new folders.

3. Initialize File Content

Put this into config/network.yaml:

network:
name: coopnet
domain: coop.local

consortium:
name: CoopConsortium

organizations:
orderer:
name: OrdererOrg
msp_id: OrdererMSP
domain: orderer.coop.local
orderers: - orderer0

headquarters:
name: HeadquartersOrg
msp_id: HQMSP
domain: hq.coop.local
peers: - peer0 - peer1

branch:
name: BranchOrg
msp_id: BranchMSP
domain: branch.coop.local
peers: - peer0 - peer1

channels:

- name: mainchannel
  consortium: CoopConsortium
  organizations:
  - HQMSP
  - BranchMSP

Stop there.

No more files yet.

4. Explain Important Sections
   network
   network:
   name: coopnet
   domain: coop.local

Defines umbrella namespace.

Used later for:

DNS
container naming
certificate CN
consortium
consortium:
name: CoopConsortium

Fabric consortium definition.

Used in genesis block.

Meaning:

these orgs may create channels together.

orderer org
orderer:

Consensus org.

Contains:

msp_id: OrdererMSP

Must be consistent forever.

Changing later is painful.

headquarters

Business HQ node.

Contains:

2 peers.

Why 2:

redundancy
gossip
future endorsement policy flexibility
branch

Same reason.

channels

Initial channel:

mainchannel

Simple MVP.

Everything on one ledger first.

Later:

auditchannel
financechannel

possible.

Why YAML?

Because later scripts can parse it.

Possible automation:

generate-config.sh
generate-compose.sh

from one source-of-truth.

Very scalable.

5. Relationship to Previous / Next Step

Previous:

Step 1 created project skeleton.

This step fills:

core blueprint.

Next:

Step 3:

Create:

config/crypto-config.yaml

derived from this blueprint.

Used by:

cryptogen

for certificate generation.

Flow:

network.yaml
↓
crypto-config.yaml
↓
cryptogen
↓
organizations/ 6) Validation

Validate:

A. YAML format

Run:

cat config/network.yaml

Check indentation.

B. Logical validation

You should clearly see:

Orderer:

1 org
1 orderer

HQ:

2 peers

Branch:

2 peers

Channel:

mainchannel

Consortium:

CoopConsortium
C. Naming validation

MSP names unique:

OrdererMSP
HQMSP
BranchMSP

No duplicates.

If valid:

✅ Step 2 complete.

Create the file content, validate it, then tell me:

Step 2 done

Then we move to Step 3 (build crypto-config.yaml for Cryptogen).
