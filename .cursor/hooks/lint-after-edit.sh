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

if ! hook_require_after_file_edit "$input"; then
  hook_emit_empty
fi

file_path=$(
  printf '%s' "$input" | hook_python -c "import json, sys; print(json.load(sys.stdin).get('file_path', ''))"
)

if [[ -z "$file_path" ]] || ! hook_is_product_code_path "$file_path"; then
  hook_emit_empty
fi

hook_mark_agent_edited
hook_append_agent_edited_path "$file_path"

case "$file_path" in
  *.py)
    if [[ -f "$file_path" ]]; then
      hook_make fmt-file "file=${file_path}" || true
      hook_make lint-file "file=${file_path}" || true
    fi
    ;;
esac

hook_emit_empty
