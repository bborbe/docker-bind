# Changelog

All notable changes to this project will be documented in this file.

Please choose versions by [Semantic Versioning](http://semver.org/).

* MAJOR version when you make incompatible API changes,
* MINOR version when you add functionality in a backwards-compatible manner, and
* PATCH version when you make backwards-compatible bug fixes.

## Unreleased

- fix: `make build` refuses to stamp a version onto a tree that is not that version's tag (`check-version-tag`, escape hatch `ALLOW_UNTAGGED_BUILD=1`). `VERSION` defaults to the newest tag repo-wide, so an operator-run build from an untagged or older tree silently republishes under the newest tag. The guard compares `git describe --exact-match HEAD` against `$(VERSION)` and exits non-zero on mismatch.

## 1.4.1

- Remove unused DOCKER_REGISTRY and BRANCH variables

## 1.4.0

- Add OCI labels for container metadata
- Add build metadata with version tracking
- Add entrypoint script to display build information
- Improve Makefile with BuildKit and platform specification

## 1.3.0

- Update to Ubuntu 22.04

## 1.2.0

- Add dns-root-data

## 1.1.0

- Update to Ubuntu 18.04

## 1.0.2

- Ubuntu 16.04
