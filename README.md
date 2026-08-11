# Super Workflow

Reusable workflow instructions for AI coding agents.

Super Workflow is a public-safe template for teams and solo developers who use tools like Codex, Claude Code, or other agentic coding assistants. It turns repeated process expectations into durable instructions: when to ask before acting, how to validate backend/API changes, how to avoid skipped tests, and how to publish reusable workflow rules without leaking private operational details.

The project started from a real developer workflow: keep the agent aligned with the developer's process, reduce ambiguous handoffs, and make "done" mean checked, verified, and clearly reported.

## Why It Exists

AI coding agents are useful, but they drift when instructions are vague or only live in chat history. Common failure modes include:

- implementing before the user approved the plan;
- skipping backend availability checks before curl/API testing;
- rebuilding a production container with development or localhost environment values;
- giving setup/auth instructions from stale memory instead of official docs;
- mixing private server sync details into public templates;
- reporting "done" without enough validation detail.

Super Workflow gives those expectations a reusable shape.

## What Is Included

- `templates/AGENTS.md`: durable rules for Codex and other agents that read `AGENTS.md`.
- `templates/CLAUDE.md`: Claude Code-compatible wrapper that imports `AGENTS.md`.
- `templates/interaction-rules.md`: hook-style version of the same working rules.
- `scripts/build-public.sh`: builds public workflow files from templates by default.
- `scripts/rename-codex-session.sh`: renames the active Codex session through the App Server protocol.
- `scripts/sanitize-public.sh`: blocks likely private operational details before publishing.
- `scripts/publish-public.sh`: publishes generated public workflow files to a configured repository.
- `.env.example`: all local/private configuration lives in `.env`, not in committed files.

## Core Principles

- **Ask before acting:** planning and implementation stay separate unless the user gives a clear go-ahead.
- **Verify before reporting:** tests, typechecks, service checks, and curl/API checks happen in the right order.
- **Docs before setup advice:** install, auth, and configuration guidance should be checked against current official docs or another primary source.
- **Production environment validation:** compare Docker production builds with the canonical deployment environment and verify build-time values before rollout.
- **Configuration over hardcoding:** operational values belong in `.env`.
- **Public-safe publishing:** reusable output must not contain private hosts, internal repo names, account identifiers, credentials, or private paths.

## Quick Start

```bash
cp .env.example .env
```

Edit `.env` for your local environment.

```bash
./scripts/build-public.sh
```

Review the generated files:

```bash
ls public
```

If `PUBLIC_REPO_URL` is configured and the output is clean:

```bash
./scripts/publish-public.sh
```

## Using With Codex

Codex reads `AGENTS.md` automatically when it is present in a repository, and can also use a global `~/.codex/AGENTS.md`.

For a repo-level setup:

```bash
cp templates/AGENTS.md /path/to/your-project/AGENTS.md
```

For a global personal setup:

```bash
mkdir -p ~/.codex
cp templates/AGENTS.md ~/.codex/AGENTS.md
```

Install the session-renaming helper somewhere on your `PATH`:

```bash
mkdir -p ~/.local/bin
ln -sfn "$(pwd)/scripts/rename-codex-session.sh" ~/.local/bin/codex-rename-session
```

The helper uses the `CODEX_THREAD_ID` exposed by an active Codex session and the version-matched App Server protocol. It requires `codex` and `jq`:

```bash
codex-rename-session my-feature-branch
```

When the helper is installed, the workflow templates direct the agent to rename the session automatically after publishing an issue branch. No manual `/rename` gate is required.

## Using With Claude Code

Claude Code reads `CLAUDE.md`. The template imports `AGENTS.md` so shared rules can stay in one place:

```md
@AGENTS.md
```

For a repo-level setup:

```bash
cp templates/AGENTS.md /path/to/your-project/AGENTS.md
cp templates/CLAUDE.md /path/to/your-project/CLAUDE.md
```

## Backend/API/Proxy Validation Rule

The template is intentionally strict about backend work:

1. Run compatible automated checks first.
2. Explicitly confirm the relevant backend/service is running and responding.
3. Run curl/API tests for changed or affected paths when reachable.
4. If curl/API testing cannot run, report the concrete blocker.

This rule exists because "tests passed" is not enough when the changed behavior lives behind a running service or proxy.

## Production Docker Environment Validation

Before rebuilding or recreating a production Docker Compose service:

1. Identify the canonical production deployment environment.
2. Compare its required URLs, hosts, API endpoints, and Socket/WebSocket endpoints with the proposed build environment.
3. Reject `localhost`, loopback addresses, development domains, and blank required values in production configuration.
4. If the frontend can inline environment variables during its build, inspect the generated production bundle for incorrect values.
5. Test the affected frontend, API, and Socket/WebSocket endpoints before reporting deployment success.

This check is especially important when the Docker build context is a development checkout whose `.env` may differ from the canonical production deployment.

## Public Safety

Do not commit:

- real server names or SSH topology;
- internal repo or project names;
- account IDs, user emails, credentials, tokens, or secrets;
- private local paths;
- organization-specific operational details that should not be reusable.

Use placeholders such as `SOURCE_HOST`, `TARGET_HOSTS`, `PUBLIC_REPO_URL`, and `PRIVATE_TERMS`.

## Project Status

This is an early public template. The goal is to make agent workflow discipline easier to copy, adapt, and improve across projects.

Contributions are welcome, especially:

- workflow rules that reduce real agent failure modes;
- portable examples for Codex, Claude Code, and similar tools;
- safer sanitization checks;
- clearer validation/reporting templates.

## License

MIT. See [LICENSE](LICENSE).
