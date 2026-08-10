# Contributing

Thanks for improving Super Workflow.

This project is about practical workflow rules for AI coding agents. Contributions should be reusable, public-safe, and based on real developer friction.

## Good Contributions

- Clearer agent instruction templates.
- Validation rules that prevent skipped tests or incomplete verification.
- Examples for Codex, Claude Code, and similar tools.
- Safer public sanitization checks.
- Documentation that helps teams adapt the workflow without copying private details.

## Public-Safety Rules

Do not include:

- real server names or SSH topology;
- private repo, project, customer, or company names;
- account IDs, emails, tokens, credentials, or secrets;
- private local paths;
- operational details that should not be reusable by another team.

Use placeholders and `.env.example` instead.

## Local Checks

Run:

```bash
./scripts/build-public.sh
```

Run:

```bash
bash -n scripts/build-public.sh scripts/sanitize-public.sh scripts/publish-public.sh scripts/rename-codex-session.sh
```

If you change public-facing output, inspect `public/` before committing.

## Pull Request Expectations

- Explain the workflow problem being solved.
- Keep the change portable.
- Mention any validation performed.
- Avoid unrelated rewrites.
