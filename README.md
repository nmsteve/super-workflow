# Super Workflow

Reusable AI agent workflow instructions, validation rules, and sync templates for teams that use Codex, Claude Code, or similar coding agents.

This repository is designed to be public-safe. Put private hosts, paths, repo URLs, account IDs, and organization-specific names in `.env`, not in committed files.

## What This Provides

- Portable `AGENTS.md` and `CLAUDE.md` instruction templates.
- Backend/API/proxy validation rules that require automated checks, service availability checks, and curl/API testing when reachable.
- Setup guidance that tells agents to confirm install/auth/config commands from official docs before answering.
- Scripts that read operational values from `.env` instead of hardcoding private details.
- A sanitization step for publishing a reusable public copy.

## Quick Start

```bash
cp .env.example .env
```

Edit `.env` with local paths and any private terms that must be redacted.

```bash
./scripts/build-public.sh
```

If you configured `PUBLIC_REPO_URL`, publish with:

```bash
./scripts/publish-public.sh
```

## Agent Instructions

When an AI agent sets up this workflow:

1. Inspect `.env.example`.
2. Create or update `.env` with local values.
3. Keep `.env` uncommitted.
4. Run `./scripts/build-public.sh`.
5. Review generated files under `public/` for private details before publishing.
6. Run `./scripts/publish-public.sh` only after the public output is clean.

## Public Safety

Do not commit:

- Real server names or SSH topology.
- Internal repo or project names.
- Account IDs, user emails, credentials, tokens, or secrets.
- Private local paths.
- Organization-specific operational details that should not be reusable.

Use placeholders such as `SOURCE_HOST`, `TARGET_HOSTS`, `PUBLIC_REPO_URL`, and `PRIVATE_TERMS`.
