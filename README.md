<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

[![OpenSSF Best Practices](https://img.shields.io/badge/OpenSSF-Best_Practices-green?logo=opensourcesecurity)](https://www.bestpractices.dev/en/projects/new?repo_url=https://github.com/hyperpolymath/bgp-backbone-lab)
[![License: PMPL-1.0](https://img.shields.io/badge/License-MPL--2.0-blue.svg)](https://github.com/hyperpolymath/palimpsest-license) <embed
src="https://api.thegreenwebfoundation.org/greencheckimage/github.com"
data-link="https://www.thegreenwebfoundation.org/green-web-check/?url=github.com" />

# Purpose

Private BGP routing, ASN allocation, route maps, and backbone simulation
for the FlatRacoon Network Stack.

Provides a lab environment for developing and testing BGP configurations
before deployment to production network infrastructure.

Part of the [FlatRacoon Network
Stack](https://github.com/hyperpolymath/flatracoon-netstack).

# Architecture

                        ┌─────────────────────┐
                        │   Transit Provider  │
                        │   AS 64500          │
                        └──────────┬──────────┘
                                   │ eBGP
                  ┌────────────────┼────────────────┐
                  │                │                │
         ┌────────▼────────┐       │       ┌────────▼────────┐
         │   Edge Router   │       │       │   Edge Router   │
         │   AS 65001      │       │       │   AS 65002      │
         │   Site A        │       │       │   Site B        │
         └────────┬────────┘       │       └────────┬────────┘
                  │                │                │
                  │ iBGP           │ iBGP           │ iBGP
                  │                │                │
         ┌────────▼────────────────▼────────────────▼────────┐
         │              Core Backbone (iBGP Mesh)             │
         │  ┌─────────┐    ┌─────────┐    ┌─────────┐        │
         │  │ Router  │◄──►│ Router  │◄──►│ Router  │        │
         │  │   R1    │    │   R2    │    │   R3    │        │
         │  └─────────┘    └─────────┘    └─────────┘        │
         └────────────────────────────────────────────────────┘
                                   │
                  ┌────────────────┼────────────────┐
                  │                │                │
         ┌────────▼────────┐ ┌─────▼─────┐ ┌───────▼───────┐
         │   ZeroTier      │ │   IPFS    │ │   Services    │
         │   Overlay       │ │   Nodes   │ │   (K8s)       │
         └─────────────────┘ └───────────┘ └───────────────┘

# Components

- **GNS3/Containerlab topology** - Network simulation environment

- **FRRouting configuration** - BGP daemon configs

- **Route maps and policies** - Traffic engineering rules

- **ASN allocation** - Private ASN management

- **Monitoring** - BGP session and route monitoring

# Directory Structure

    bgp-backbone-lab/
    ├── topologies/
    │   ├── simple-mesh.yaml       # Containerlab topology
    │   ├── dual-homed.yaml        # Dual-homed design
    │   ├── full-mesh.yaml         # Full iBGP mesh
    │   └── route-reflector.yaml   # Route reflector design
    ├── configs/
    │   ├── frr/                   # FRRouting configurations
    │   │   ├── edge-router.ncl
    │   │   ├── core-router.ncl
    │   │   └── route-reflector.ncl
    │   ├── route-maps.ncl         # Route map definitions
    │   ├── prefix-lists.ncl       # Prefix list definitions
    │   └── communities.ncl        # BGP community definitions
    ├── scripts/
    │   ├── deploy-lab.sh          # Lab deployment
    │   ├── validate-routes.sh     # Route validation
    │   ├── traffic-eng.sh         # Traffic engineering tests
    │   └── failover-test.sh       # Failover testing
    ├── docs/
    │   ├── asn-allocation.adoc    # ASN registry
    │   ├── prefix-allocation.adoc # IP prefix registry
    │   └── design-decisions.adoc  # Architecture notes
    ├── Justfile
    ├── README.adoc
    ├── STATE.scm
    ├── META.scm
    └── ECOSYSTEM.scm

# Inputs

| Input | Description | Source |
|----|----|----|
| ASN allocation | Private ASN numbers (64512-65534) | docs/asn-allocation.adoc |
| Prefix allocation | IPv4/IPv6 prefixes to announce | docs/prefix-allocation.adoc |
| Topology definition | Network topology YAML | topologies/\*.yaml |
| Routing policy | Route maps and filters | configs/\*.ncl |

# Outputs

| Output                   | Description                      |
|--------------------------|----------------------------------|
| Running lab environment  | Containerlab network simulation  |
| Validated configurations | Production-ready FRR configs     |
| Route tables             | Exported BGP RIB                 |
| Test results             | Failover and convergence metrics |

# ASN Allocation

| ASN   | Role               | Description                 |
|-------|--------------------|-----------------------------|
| 64512 | Transit simulation | Simulated upstream provider |
| 65001 | Site A edge        | Primary site edge router    |
| 65002 | Site B edge        | Secondary site edge router  |
| 65010 | Route reflector    | iBGP route reflector        |
| 65100 | ZeroTier overlay   | ZeroTier network routing    |

# Integration Points

## With FlatRacoon Stack

- **zerotier-k8s-link** - Overlay routes announced via BGP

- **ipv6-site-enforcer** - IPv6 prefix announcements

- **network-dashboard** - BGP session monitoring

## Machine-Readable Manifest

```json
{
  "module": "bgp-backbone-lab",
  "version": "0.1.0",
  "layer": "network",
  "requires": ["containerlab", "frrouting"],
  "provides": ["bgp-simulation", "route-validation", "traffic-engineering"],
  "config_schema": "configs/schema.ncl",
  "health_endpoint": "n/a",
  "metrics_endpoint": "/bgp/metrics"
}
```

# Quick Start

```bash
# 1. Start Containerlab topology
just deploy simple-mesh

# 2. Verify BGP sessions
just bgp-summary

# 3. Check route propagation
just show-routes

# 4. Run failover test
just failover-test edge-router-1

# 5. Export production configs
just export-configs
```

# Example BGP Configuration (FRR)

    router bgp 65001
     bgp router-id 10.0.0.1
     no bgp default ipv4-unicast
     neighbor IBGP peer-group
     neighbor IBGP remote-as 65001
     neighbor IBGP update-source lo
     neighbor 10.0.0.2 peer-group IBGP
     neighbor 10.0.0.3 peer-group IBGP
     !
     address-family ipv6 unicast
      network 2001:db8:face::/48
      neighbor IBGP activate
      neighbor IBGP route-reflector-client
     exit-address-family

# Status

Phase  
Scaffolding

Completion  
5%

Next  
Containerlab topology definitions

# License

MPL-2.0
