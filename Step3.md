# STEP 3 — Create Cryptogen Configuration (config/crypto-config.yaml)

At this step we are not generating certificates yet.

We only create the configuration file that tells cryptogen what identities to generate.

Stop there.

No Docker yet.
No cryptogen generate yet.
No genesis block yet.

## 1. Purpose in Cooperative Architecture

In Hyperledger Fabric, every node is identified by X.509 certificates.

That means:

Each of these needs identity:

orderer0
peer0 HQ
peer1 HQ
peer0 Branch
peer1 Branch
admins
users
TLS identities
organization MSP identities

Without certificates:

peers cannot join
orderer cannot sign blocks
MSP cannot validate signatures
channel membership fails
endorsement fails

So this step defines:

Who receives certificates

For your cooperative:

OrdererOrg → orderer0

HeadquartersOrg
├─ peer0
└─ peer1

BranchOrg
├─ peer0
└─ peer1

And each gets:

MSP certs
TLS certs
admin certs
user certs 

## 2) File / Folder Structure

Create:

config/
├── network.yaml
└── crypto-config.yaml

Only one new file.

Nothing else.

## 3. Initialize File

Create:

config/crypto-config.yaml

Content:

OrdererOrgs:

- Name: OrdererOrg
  Domain: orderer.coop.local
  Specs:
  - Hostname: orderer0

PeerOrgs:

- Name: HeadquartersOrg
  Domain: hq.coop.local
  EnableNodeOUs: true
  Template:
  Count: 2
  Users:
  Count: 1

- Name: BranchOrg
  Domain: branch.coop.local
  EnableNodeOUs: true
  Template:
  Count: 2
  Users:
  Count: 1

Stop there.

No commands yet.

## 4. Explain Important Sections
   OrdererOrgs

Defines ordering organization.

OrdererOrgs:

Means:

Fabric creates:

ordererOrganizations/orderer.coop.local/

inside organizations.

Contains:

MSP
TLS
admin cert
orderer cert
Name
Name: OrdererOrg

Logical org name.

Later maps to:

OrdererMSP

in configtx.

Keep consistent.

Domain
Domain: orderer.coop.local

Used for DNS / CN.

Generated node:

orderer0.orderer.coop.local

Full hostname.

Specs

Explicit host list.

Specs:

- Hostname: orderer0

Generates:

1 orderer.

Later:

- Hostname: orderer1
- Hostname: orderer2

for Raft scaling.

PeerOrgs

Defines peer organizations.

HeadquartersOrg
Name: HeadquartersOrg
Domain: hq.coop.local

Generates:

peer0.hq.coop.local
peer1.hq.coop.local
EnableNodeOUs
EnableNodeOUs: true

Very important.

Enables Fabric role separation:

peer
client
admin
orderer

Modern Fabric expects this.

Do not disable.

Template Count
Count: 2

Generates:

peer0
peer1

Automatically.

Users
Users:
Count: 1

Creates default user cert.

Used for admin/client operations.

Later with Fabric CA this becomes dynamic.

BranchOrg

Same logic.

## 5. Relationship to Previous / Next Step

Previous:

Step 2 defined architecture blueprint:

who exists

This step converts that into:

certificate generation blueprint

Flow:

network.yaml
↓
crypto-config.yaml

Next step:

Step 4:

actually run:

cryptogen generate

which creates:

organizations/

full PKI structure.

Flow:

crypto-config.yaml
↓
cryptogen
↓
organizations/ 6) Validation (Do Not Generate Yet)

Validate file exists:

tree config

Expected:

config
├── crypto-config.yaml
└── network.yaml

Validate logic:

Checklist:

Orderer:

1 orderer org
1 node (orderer0)

HQ:

2 peers

Branch:

2 peers

NodeOUs:

enabled on peer orgs

Users:

one default user per org

Validate naming consistency with network.yaml:

Domains match:

network.yaml:

orderer.coop.local
hq.coop.local
branch.coop.local

crypto-config must match exactly.

No typo allowed.

If correct:

✅ Step 3 complete.

Create config/crypto-config.yaml, validate it, then tell me:

Step 3 done

Then we proceed to Step 4 — generate certificates with cryptogen (and only that).
