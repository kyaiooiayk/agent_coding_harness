#!/usr/bin/env bash
set -euo pipefail

input=$(cat)

if [[ -n "${HOOK_REPO_ROOT:-}" ]]; then
  root="$HOOK_REPO_ROOT"
else
  root="$(cd "$(dirname "$0")/../.." && pwd)"
fi
cd "$root"
export HOOK_REPO_ROOT="$root"
hooks_dir="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_common.sh
source "$hooks_dir/_common.sh"

cleanup() {
  hook_release_stop_gate
}
trap cleanup EXIT

hook_prepare_stop_hook "$input" "stop-gate-on-stop"

loop_count=$(
  printf '%s' "$input" | hook_python -c "import json, sys; print(json.load(sys.stdin).get('loop_count', 0))"
)

hook_acquire_stop_gate

hook_run_step_followup "make lint" hook_make lint

hook_run_step_followup "make dev-build" hook_run_dev_build

hook_run_step_followup "make test parallel=true" hook_make test parallel=true

hook_clear_agent_edited
hook_clear_agent_edited_paths
hook_clear_stop_phase_stamps
hook_emit_empty
