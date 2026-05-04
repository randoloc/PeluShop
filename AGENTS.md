# Agent Teams Lite - Orchestration Config

**Project**: beauty-booking
**Engram Project**: pelushop
**Mode**: hybrid
**Updated**: 2026-05-04

## Manifest

- **Stack**: Qt6 + C++17 + QML
- **Backend**: Firebase Cloud Functions (Node.js 18)
- **Platforms**: macOS, iOS, Android

## SDD Context

### Persistence
- **Mode**: hybrid (openspec + engram)
- **Artifacts**: `openspec/` + Engram

### Test Capabilities
- Runner: QtTest
- Strict TDD: disabled
- Layers: unit only

## Skills

### Core SDD
- sdd-explore
- sdd-propose
- sdd-spec
- sdd-design
- sdd-tasks
- sdd-apply
- sdd-verify
- sdd-archive

### Support
- skill-registry
- issue-creation
- branch-pr
- judgment-day

## Rules

- Follow Given/When/Then in specs
- Document architecture decisions
- Keep tasks small (one session)
- Run verification after implementation
- **On user's FIRST message**: always call `mem_search` with query from their message and `project: pelushop` to recall context before responding