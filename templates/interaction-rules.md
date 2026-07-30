# Active working rules

- **Gate on go-ahead / answer-only:** when asked a question, answer only until explicitly told to proceed.
- **Ask in plain text:** when you need to ask a question or request confirmation, put it in your plain-text reply; do not use a question-screen / multiple-choice picker UI. When selectable options are needed, number questions sequentially (`1`, `2`, etc.) and label choices with sequential lowercase letters (`a`, `b`, `c`, etc.). Do not add a redundant reply-format instruction when the expected response is already clear from the question and choices.
- **Plan before issue prompts:** when asked to work on something, plan first and present the plan; ask about creating an issue only at the end, after the plan — not upfront.
- **Summarize before & after:** summarize the understanding before work and summarize changed files after work.
- **Setup docs confirmation:** before setup, install, auth, or config guidance, confirm current commands from official docs or another reliable primary source.
- **Configuration-driven scripts:** use `.env` for private local values. Do not hardcode hosts, paths, repo URLs, credentials, or account identifiers in public scripts.
- **Public-safe publishing:** public workflow output must be useful as a reusable template and must not include private operational details.
- **Public workflow publishing after rule updates:** after every global/working instruction rule update, also update and push the configured public workflow repository when the change is reusable and public-safe, even if the public wording needs later refinement, so changes are retained remotely. If the rule contains private operational details or is not appropriate for public reuse, do not publish it publicly and state why.
- **Session rename suggestion:** after creating and publishing an issue branch, optionally suggest renaming the current session to match the exact branch name by showing `/rename <branch-name>`. Under the standard branch convention, this is `/rename <issue-number>-<short-description>`. Never execute the rename automatically, and do not change the established branch naming convention.
- **Dependent feature branch workflow:**
  1. Fetch the latest upstream base before creating or updating a feature branch.
  2. Determine whether the new work depends on another feature branch.
  3. If there is no unmerged dependency, create the branch from the latest upstream base.
  4. If the dependency is unmerged, create the branch from that dependency branch.
  5. Before opening or updating a PR, check whether the dependency has merged and whether upstream has advanced.
  6. If the dependency has merged or upstream has advanced, rebase the appropriate branch onto the latest upstream base.
  7. Update stacked branches from oldest to newest.
  8. Verify that each PR contains only its intended changes before marking it ready or merging it.
- **Commit and push after AI work:** after every completed AI task that changes files in a Git repository, run the required validation, commit the completed changes, and push the branch to its configured remote. If no remote is configured, the work is intentionally local/private, or the user explicitly requested no commit/push, state that commit/push was skipped and why.
- **Backend/API/proxy validation:** run automated checks first, explicitly confirm the relevant backend/service is running and responding second, then run curl/API tests third when reachable. Report concrete blockers when curl/API tests cannot run.
