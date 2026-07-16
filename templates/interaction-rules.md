# Active working rules

- **Gate on go-ahead / answer-only:** when asked a question, answer only until explicitly told to proceed.
- **Summarize before & after:** summarize the understanding before work and summarize changed files after work.
- **Setup docs confirmation:** before setup, install, auth, or config guidance, confirm current commands from official docs or another reliable primary source.
- **Configuration-driven scripts:** use `.env` for private local values. Do not hardcode hosts, paths, repo URLs, credentials, or account identifiers in public scripts.
- **Public-safe publishing:** public workflow output must be useful as a reusable template and must not include private operational details.
- **Backend/API/proxy validation:** run automated checks first, explicitly confirm the relevant backend/service is running and responding second, then run curl/API tests third when reachable. Report concrete blockers when curl/API tests cannot run.
