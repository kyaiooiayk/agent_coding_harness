# Cursor project config

Agent behaviour is driven by **rules** (`.cursor/rules/`), **skills** (`.cursor/skills/`), **hooks** (`.cursor/hooks/`), and optional **specialist subagents** (`.cursor/agents/`). Start with [`AGENTS.md`](../AGENTS.md) at the repo root. OKF knowledge: [`index.md`](../index.md).

| Rule | Scope |
| --- | --- |
| [`.cursor/rules/okf.mdc`](rules/okf.mdc) | OKF: `knowledge/` human files + agent frontmatter only; `docs/` agent-writable; service READMEs not OKF |
| [`.cursor/rules/harness-hotline.mdc`](rules/harness-hotline.mdc) | Short always-on test/bug punchlines — depth rules open on demand (`docs/agent_context_disclosure.md`) |

---

## Local vs remote

**Single path** — Cursor project config for the laptop IDE/agent harness only; it does not change between Compose and AWS deployments of the product.

---

## Frontend (UI + BFF pairing)

When editing `frontend/` or adding BFF routes that serve the SPA:

| Rule | Scope |
| --- | --- |
| [`.cursor/rules/frontend-styling.mdc`](rules/frontend-styling.mdc) | **CSS, dark/light theme tokens, contrast** — use `var(--…)` from `App.css`; test both `dark` and `light`; no hardcoded surface/text colors in component CSS |
| [`.cursor/rules/frontend-tsc-gate.mdc`](rules/frontend-tsc-gate.mdc) | **`npm run build` / tsc**, API client signatures, static routes before `{param}`, multipart deps |

Human overview: [`frontend/README.md`](../frontend/README.md) (routes, auth, **styling and theme**).

---

## E2E session and auth cleanup (always enforce)

Browser E2E tests **must not leak sessions**. A missed hard-delete on a recurring job setup can spawn thousands of run sessions.
Journey login uses seeded `test`; auth provisioning identities use only `e2eoidc-` /
`e2ereg-` prefixes and must be wrapped by the disposable auth context managers.

| What | Where |
| --- | --- |
| **Rule (agents editing `e2e_test/`)** | [`.cursor/rules/e2e-session-cleanup.mdc`](rules/e2e-session-cleanup.mdc) |
| **Human + agent contract** | [`e2e_test/README.md`](../e2e_test/README.md) § Session cleanup guard |
| **Implementation** | [`e2e_test/session_cleanup.py`](../e2e_test/session_cleanup.py), autouse `_e2e_session_cleanup_guard` in [`e2e_test/conftest.py`](../e2e_test/conftest.py) |
| **CI-style audit** | [`e2e_test/test_e2e_session_guard_audit.py`](../e2e_test/test_e2e_session_guard_audit.py) |
| **Auth disposable audit** | [`e2e_test/test_auth_disposable_guard_audit.py`](../e2e_test/test_auth_disposable_guard_audit.py) |

**Do not** add E2E tests that create sessions without
`register_e2e_session_for_cleanup` or an approved helper. Do not use bare auth identity
factories in browser tests. **Do not** disable the autouse guard.

---

## Hooks

Format on agent edit; lint + test gate on handback: [`.cursor/hooks/README.md`](hooks/README.md).
