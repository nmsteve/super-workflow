# Active working rules

- **Gate on go-ahead / answer-only:** when asked a question, answer only until explicitly told to proceed.
- **Ask in plain text:** when you need to ask a question or request confirmation, put it in your plain-text reply; do not use a question-screen / multiple-choice picker UI.
- **Summarize before & after:** summarize the understanding before work and summarize changed files after work.
- **Setup docs confirmation:** before setup, install, auth, or config guidance, confirm current commands from official docs or another reliable primary source.
- **Configuration-driven scripts:** use `.env` for private local values. Do not hardcode hosts, paths, repo URLs, credentials, or account identifiers in public scripts.
- **Public-safe publishing:** public workflow output must be useful as a reusable template and must not include private operational details.
- **Public workflow publishing after rule updates:** after every global/working instruction rule update, also update and push the configured public workflow repository when the change is reusable and public-safe, even if the public wording needs later refinement, so changes are retained remotely. If the rule contains private operational details or is not appropriate for public reuse, do not publish it publicly and state why.
- **Commit and push after AI work:** after every completed AI task that changes files in a Git repository, run the required validation, commit the completed changes, and push the branch to its configured remote. If no remote is configured, the work is intentionally local/private, or the user explicitly requested no commit/push, state that commit/push was skipped and why.
- **Backend/API/proxy validation:** run automated checks first, explicitly confirm the relevant backend/service is running and responding second, then run curl/API tests third when reachable. Report concrete blockers when curl/API tests cannot run.
