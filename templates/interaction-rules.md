# Active working rules

- **Gate on go-ahead / answer-only:** when asked a question, answer only until explicitly told to proceed.
- **Ask in plain text:** when you need to ask a question or request confirmation, put it in your plain-text reply; do not use a question-screen / multiple-choice picker UI. For a single selectable question, omit the question number and label choices with sequential lowercase letters (`a`, `b`, `c`, etc.). For multiple selectable questions, number the questions sequentially (`1`, `2`, etc.) and use lowercase lettered choices beneath each one. Do not add a redundant reply-format instruction when the expected response is already clear from the question and choices.
- **Plan before issue prompts:** when asked to work on something, plan first and present the plan; ask about creating an issue only at the end, after the plan — not upfront.
- **Broad issue scope, fix during testing:** prefer fewer, broader-scoped issues over many narrow follow-up issues. While testing an issue's work, fix anything found broken or missing directly under the current issue instead of stopping to file a separate follow-up. Only create a separate issue when the problem is clearly outside the current issue's area.
- **Summarize before & after:** summarize the understanding before work and summarize changed files after work.
- **Brief task summaries:** report finished work in three sections — **Results** (what happened, plus the changed-file links), **Considerations** (open choices), **Action needed** (concrete next steps and blockers). Write each section heading as a markdown level-2 heading (`## Results`, `## Considerations`, `## Action needed`) so it renders large and bold. Do not number the section headings themselves. All three sections use the same structure: sequential numbered points (`1.`, `2.`, `3.`) with a blank line before every point. Lettered options (`a.`, `b.`) appear beneath a point only where a real decision is open — Considerations always, with one marked *(recommended)*; Action needed when the next step has genuine choices; Results never, since it reports what happened. In Results, each changed-file link is its own numbered point at the same level as the narrative points, on its own straight line. Never nest a plain, unlettered line beneath a numbered point: the terminal renderer turns it into a new list item and collapses the spacing around the surrounding points. Lettered options are the only thing that may sit beneath a numbered point. Spacing is required, not optional, and is the single most-missed part of this rule: put a blank line above each section heading, a blank line between each lettered option, and a blank line before every numbered point. The blank line before a numbered point is mandatory even when the line above it is the last lettered option of the previous point — that is exactly the place it gets dropped. No numbered point may ever sit on the line directly after an option, so `1.`, `2.`, `3.` never run together. Follow this literal shape:

      ## Results

      1. <what happened>

      2. [file.ts](/abs/path/file.ts:12) - <short description>

      3. [other.ts](/abs/path/other.ts:40) - <short description>

      4. <what happened>

      ## Considerations

      1. <first decision>

         a. <option> *(recommended)*

         b. <option>

      2. <second decision>

         a. <option> *(recommended)*

         b. <option>

      ## Action needed

      1. <next step or blocker>

      2. <next step with genuine choices>

         a. <option> *(recommended)*

         b. <option>
 Terse throughout; no preamble or restatement. Use `None.` for an empty section. Only raise a Consideration where a real decision is open — don't manufacture choices.
- **Design confirmation gate:** for design work, first create a sketch or wireframe when practical, present it to the user, and receive explicit confirmation before implementing the final design.
- **Setup docs confirmation:** before setup, install, auth, or config guidance, confirm current commands from official docs or another reliable primary source.
- **Production Docker environment validation:** before rebuilding or recreating a production Docker Compose service, identify the canonical production deployment environment and compare it with the proposed build environment. Reject production-facing URLs, hosts, API endpoints, and Socket/WebSocket endpoints that contain `localhost`, loopback addresses, development domains, or blank required values. When frontend tools may inline environment variables at build time, inspect the generated production bundle and test the affected public endpoints before reporting deployment success. Do not build production from a development checkout's `.env` unless its production values have been explicitly validated.
- **Configuration-driven scripts:** use `.env` for private local values. Do not hardcode hosts, paths, repo URLs, credentials, or account identifiers in public scripts.
- **Public-safe publishing:** public workflow output must be useful as a reusable template and must not include private operational details.
- **Public workflow publishing after rule updates:** after every global/working instruction rule update, also update and push the configured public workflow repository when the change is reusable and public-safe, even if the public wording needs later refinement, so changes are retained remotely. If the rule contains private operational details or is not appropriate for public reuse, do not publish it publicly and state why.
- **Session rename automation:** after creating and publishing an issue branch, run `codex-rename-session <exact-branch-name>` as a normal implementation step and continue without pausing for user confirmation. Do not display or ask the user to run `/rename`. If the helper is unavailable or fails, report the concrete error and continue without blocking implementation; do not change the established branch naming convention.
- **Dependent feature branch workflow:**
  1. Fetch the latest upstream base before creating or updating a feature branch.
  2. Determine whether the new work depends on another feature branch.
  3. If there is no unmerged dependency, create the branch from the latest upstream base.
  4. If the dependency is unmerged, create the branch from that dependency branch.
  5. Before opening or updating a PR, check whether the dependency has merged and whether upstream has advanced.
  6. If the dependency has merged or upstream has advanced, rebase the appropriate branch onto the latest upstream base.
  7. Update stacked branches from oldest to newest.
  8. Verify that each PR contains only its intended changes before marking it ready or merging it.
- **Pull request base enforcement:** before opening a pull request, verify that its destination is the repository's recorded long-lived base branch, such as `main`, `master`, or `development`. For a normal repository, open the PR against the base branch on `origin`. For a forked repository, open the fork PR against the base branch on `origin` and the upstream PR against the corresponding base branch on `upstream`. Never open a PR against a feature, task, or dependency branch.
- **Commit and push after AI work:** after every completed AI task that changes files in a Git repository, run the required validation, commit the completed changes, and push the branch to its configured remote. If changed files are in a Git repository but no remote is configured, the work is intentionally local/private, or the user explicitly requested no commit/push, state that commit/push was skipped and why. Do not mention commit/push for tasks that do not change files in a Git repository unless it is relevant or the user asks.
- **Pull-request naming and readiness:** set each pull request title to exactly match its source branch name, preserving the full issue number, prefixes, and hyphenated slug. Open pull requests as ready for review by default; use a draft pull request only when the user explicitly requests one or the work is knowingly incomplete.
- **Backend/API/proxy validation:** run automated checks first, explicitly confirm the relevant backend/service is running and responding second, run curl/API tests third when reachable, and inspect relevant time- or trace-matched execution logs fourth when available. Confirm the matching operation, status/result, and absence of relevant errors or exceptions; an HTTP response alone is not sufficient proof that execution completed correctly. Report concrete blockers when curl/API or log verification cannot run.
- **Development-mode restart reporting:** before finishing development work, confirm how the affected app runs in development and whether hot reload or watch mode applies the changes automatically. When hot reload or watch mode applied the change, do not show a restart or rebuild warning. When only a restart is required, end the final summary with **APP NEEDS RESTART TO APPLY - restart it.** When build artifacts must be regenerated, end the final summary with **APP NEEDS REBUILD TO APPLY - rebuild and restart it.** For workspace maintenance, intentionally stopped services, or work that does not require an application to apply changes, report the status normally without either warning.
