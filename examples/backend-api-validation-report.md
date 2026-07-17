# Backend/API Validation Report

Use this format when backend, API, endpoint, or proxy behavior changes.

## Automated Checks

| Check | Result |
|---|---|
| Test runner | `PASS` |
| Typecheck | `PASS` |
| Database/schema check | `PASS` or `N/A` |

## Service Availability

| Service | Check | Result |
|---|---|---|
| Backend/API | `GET /health` | `200 OK` |

## Curl/API Tests

| Call | Request/Payload Summary | Result/Status |
|---|---|---|
| `POST /example` | Valid payload for changed behavior | `200 OK` |
| `POST /example` | Invalid payload for validation path | `400 Bad Request` |

## Blockers

Use this section only if a required check could not run. State the concrete blocker, such as:

- service unreachable;
- missing credentials;
- missing environment variables;
- unavailable database state;
- user explicitly declined.
