#!/usr/bin/env bash

hook_repo_root() {
  if [[ -n "${HOOK_REPO_ROOT:-}" ]]; then
    printf '%s' "$HOOK_REPO_ROOT"
    return 0
  fi
  local hooks_dir
  hooks_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  (cd "${hooks_dir}/../.." && pwd)
}

hook_venv_dir() {
  printf '.venv'
}

hook_venv_path() {
  local root
  root="$(hook_repo_root)"
  printf '%s/%s' "$root" "$(hook_venv_dir)"
}

hook_prepare_make_env() {
  local venv
  venv="$(hook_venv_path)"
  export UV_PROJECT_ENVIRONMENT="$venv"
  export VIRTUAL_ENV="$venv"
  export PATH="${venv}/bin:${HOME}/.local/bin:${PATH}"
}

hook_python() {
  local py
  py="$(hook_venv_path)/bin/python"
  if [[ -x "$py" ]]; then
    "$py" "$@"
  else
    python3 "$@"
  fi
}

hook_make() {
  hook_prepare_make_env
  make "$@"
}

hook_cursor_dir() {
  printf '%s/.cursor' "$(hook_repo_root)"
}

hook_agent_edited_stamp() {
  printf '%s/agent-edited.stamp' "$(hook_cursor_dir)"
}

hook_agent_edited_paths_file() {
  printf '%s/agent-edited-paths' "$(hook_cursor_dir)"
}

hook_append_agent_edited_path() {
  local file_path="$1"
  local paths_file
  paths_file="$(hook_agent_edited_paths_file)"
  file_path="$(hook_normalize_repo_path "$file_path")"
  mkdir -p "$(dirname "$paths_file")"
  printf '%s\n' "$file_path" >>"$paths_file"
}

hook_clear_agent_edited_paths() {
  rm -f "$(hook_agent_edited_paths_file)"
}

hook_run_dev_build() {
  local paths_file
  paths_file="$(hook_agent_edited_paths_file)"
  if [[ -f "$paths_file" ]] && [[ -s "$paths_file" ]]; then
    DEV_BUILD_PATHS_FILE="$paths_file" hook_make dev-build
  else
    hook_make dev-build
  fi
}

hook_plan_mode_stamp() {
  printf '%s/plan-mode.stamp' "$(hook_cursor_dir)"
}

hook_mark_agent_edited() {
  local stamp
  stamp="$(hook_agent_edited_stamp)"
  mkdir -p "$(dirname "$stamp")"
  date -u +"%Y-%m-%dT%H:%M:%SZ" >"$stamp"
}

hook_has_agent_edits() {
  [[ -f "$(hook_agent_edited_stamp)" ]]
}

hook_clear_agent_edited() {
  rm -f "$(hook_agent_edited_stamp)"
}

hook_stop_lint_ok_stamp() {
  printf '%s/stop-lint-ok.stamp' "$(hook_cursor_dir)"
}

hook_stop_dev_build_ok_stamp() {
  printf '%s/stop-dev-build-ok.stamp' "$(hook_cursor_dir)"
}

hook_clear_stop_phase_stamps() {
  rm -f "$(hook_stop_lint_ok_stamp)" "$(hook_stop_dev_build_ok_stamp)"
}

hook_mark_stop_lint_ok() {
  mkdir -p "$(hook_cursor_dir)"
  date -u +"%Y-%m-%dT%H:%M:%SZ" >"$(hook_stop_lint_ok_stamp)"
}

hook_mark_stop_dev_build_ok() {
  mkdir -p "$(hook_cursor_dir)"
  date -u +"%Y-%m-%dT%H:%M:%SZ" >"$(hook_stop_dev_build_ok_stamp)"
}

hook_has_stop_lint_ok() {
  [[ -f "$(hook_stop_lint_ok_stamp)" ]]
}

hook_has_stop_dev_build_ok() {
  [[ -f "$(hook_stop_dev_build_ok_stamp)" ]]
}

hook_prepare_stop_hook() {
  local input="$1" hook_name="$2"
  if ! hook_require_stop_event "$input"; then
    hook_emit_empty
  fi
  local status
  status="$(
    printf '%s' "$input" | hook_python -c "import json, sys; print(json.load(sys.stdin).get('status', ''))"
  )"
  if [[ "$status" == "aborted" ]]; then
    hook_emit_empty
  fi
  if hook_plan_mode_active; then
    hook_emit_empty
  fi
  if ! hook_has_agent_edits; then
    hook_emit_empty
  fi
}

hook_plan_mode_active() {
  [[ -f "$(hook_plan_mode_stamp)" ]]
}

hook_stop_gate_lock() {
  printf '%s/stop-gate.lock' "$(hook_cursor_dir)"
}

hook_acquire_stop_gate() {
  local lock
  lock="$(hook_stop_gate_lock)"
  mkdir -p "$(dirname "$lock")"
  printf '%s\n' "$$" >"$lock"
}

hook_release_stop_gate() {
  rm -f "$(hook_stop_gate_lock)"
}

hook_emit_empty() {
  printf '%s\n' '{}'
  exit 0
}

hook_require_after_file_edit() {
  local input="$1"
  if HOOK_INPUT="$input" hook_python -c '
import json, os, sys

raw = os.environ.get("HOOK_INPUT", "").strip()
if not raw:
    sys.exit(1)
try:
    payload = json.loads(raw)
except json.JSONDecodeError:
    sys.exit(1)
if payload.get("hook_event_name") not in (None, "afterFileEdit"):
    sys.exit(1)
if not payload.get("file_path"):
    sys.exit(1)
'; then
    return 0
  fi
  return 1
}

hook_require_stop_event() {
  local input="$1"
  if HOOK_INPUT="$input" hook_python -c '
import json, os, sys

raw = os.environ.get("HOOK_INPUT", "").strip()
if not raw:
    sys.exit(1)
try:
    payload = json.loads(raw)
except json.JSONDecodeError:
    sys.exit(1)
if payload.get("hook_event_name") not in (None, "stop"):
    sys.exit(1)
'; then
    return 0
  fi
  return 1
}

hook_truncate() {
  local text="$1"
  local max=4000
  if ((${#text} > max)); then
    local head=1200
    local tail=2700
    printf '%s\n...(truncated)...\n%s' "${text:0:head}" "${text: -tail}"
  else
    printf '%s' "$text"
  fi
}

hook_emit_followup() {
  local headline="$1"
  local body="$2"
  local message=$(
    cat <<EOF
Hooks blocked handback — fix the failures below, then finish.

${headline}

$(hook_truncate "$body")
EOF
  )
  hook_python -c 'import json, sys; print(json.dumps({"followup_message": sys.stdin.read()}))' <<<"$message"
  exit 0
}

hook_run_step_followup() {
  local headline="$1"
  shift
  local tmp rc
  tmp="$(mktemp "${TMPDIR:-/tmp}/hook-step.XXXXXX")"
  set +e
  "$@" >"$tmp" 2>&1
  rc=$?
  set -e
  if ((rc != 0)); then
    local body
    body="$(cat "$tmp")"
    if [[ -z "$body" ]]; then
      body="(no output; exit code ${rc})"
    fi
    hook_emit_followup "${headline} failed:" "$body"
  fi
  rm -f "$tmp"
}

hook_normalize_repo_path() {
  local file_path="$1"
  local root
  root="$(hook_repo_root)" || {
    printf '%s' "$file_path"
    return 0
  }
  case "$file_path" in
    "${root}/"*) printf '%s' "${file_path#"${root}/"}" ;;
    *) printf '%s' "$file_path" ;;
  esac
}

hook_is_product_code_path() {
  local file_path="$1"
  file_path="$(hook_normalize_repo_path "$file_path")"
  case "$file_path" in
    .cursor/* | docs/* | knowledge/* | BAU/* | *.md) return 1 ;;
    */.cursor/plans/* | */agent-tools/*) return 1 ;;
  esac
  return 0
}
