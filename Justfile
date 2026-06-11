# SPDX-License-Identifier: MPL-2.0
# Justfile for bgp-backbone-lab

default:
    @just --list

# Run panic-attack assail
assail:
    panic-attack assail .

secret-scan-trufflehog:
    @command -v trufflehog >/dev/null && trufflehog filesystem . --only-verified || true
