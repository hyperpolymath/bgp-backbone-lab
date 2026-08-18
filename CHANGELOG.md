<!--
SPDX-License-Identifier: MPL-2.0
SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell (hyperpolymath)
-->

# Changelog

All notable changes to `bgp-backbone-lab` will be documented in this file.

This file is generated from conventional commits by the
[`changelog-reusable.yml`](https://github.com/hyperpolymath/standards/blob/main/.github/workflows/changelog-reusable.yml)
workflow (`hyperpolymath/standards#206`). Adopt the workflow in this repo's CI to keep this file in sync automatically — see
[`templates/cliff.toml`](https://github.com/hyperpolymath/standards/blob/main/templates/cliff.toml)
for the canonical config.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
this project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- feat: add FlatRacoon manifest, containerlab topology, and K8s job
- feat(ci): enable Hypatia scanning
- feat: initial scaffolding for BGP backbone lab

### Fixed

- fix(licence): clear scaffold-placeholder leak (Tranche 2) (#38)
- fix(ci): sync hypatia-scan.yml to canonical (413: env.HOME+Phase-2+SARIF) (#36)
- fix(ci): adopt canonical hypatia-scan.yml (env.HOME/scanner-layout + Comment-step gate) (#34)
- fix(ci): Phase-2 fleet submission must not fail the security gate (#33)
- fix(ci): hypatia-scan workdir (${{ env.HOME }} resolves empty) (#32)
- fix(ci): move secret-scanner Cargo.toml gate from job-level if: to step-level (#30)
- fix(codeql): switch language matrix to 'actions' (no JS/TS in repo) (#29)
- fix(ci): hypatia-scan.yml -- pass GITHUB_TOKEN, use --exit-zero (hyperpolymath/hypatia#213) (#27)
- fix(ci): update hypatia binary detection in hypatia-scan workflow
- fix: remove duplicate SCM files from root

### Documentation

- docs(readme): add SPDX header and/or standard badges
- docs: add checkpoint files for state tracking

### CI

- ci(secret-scanner): drop duplicate --fail from trufflehog extra_args (#26)
- ci: bump actions/upload-artifact SHA to current v4 (#25)
- ci: fix workflow-linter YAML parse error + self-flag bug
- ci: fix workflow-linter self-flag bug

## Pre-history

Prior commits to this file's introduction are recorded in git history but not formally classified into Keep-a-Changelog sections. To backfill, run `git cliff -o CHANGELOG.md` locally using the canonical [`cliff.toml`](https://github.com/hyperpolymath/standards/blob/main/templates/cliff.toml) — this is one-shot mechanical work.

---

<!-- This file was seeded by the 2026-05-26 estate tech-debt audit follow-up (Row-2 Phase 3); see [`hyperpolymath/standards/docs/audits/2026-05-26-estate-documentation-debt.md`](https://github.com/hyperpolymath/standards/blob/main/docs/audits/2026-05-26-estate-documentation-debt.md). -->
