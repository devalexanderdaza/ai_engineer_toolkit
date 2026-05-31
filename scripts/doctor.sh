#!/usr/bin/env bash
# AI Engineer Toolkit doctor v0.1 — read-only checks, no --fix.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

resolve_toolkit_root "$SCRIPT_DIR"

DO_GLOBAL=0
DO_PROJECT=0
DO_RUNTIME=0
HOST=""
JSON_OUT=0
FAILURES=0
WARNS=0

usage() {
  cat <<'EOF'
Usage: doctor.sh [--global] [--host NAME] [--project] [--runtime] [--json]

Default (no flags): run --global, --project, and --runtime if applicable.

Exit codes: 0 = OK/WARN only, 1 = FAIL, 2 = usage error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global) DO_GLOBAL=1; shift ;;
    --project) DO_PROJECT=1; shift ;;
    --runtime) DO_RUNTIME=1; shift ;;
    --host) HOST="${2:-}"; shift 2 ;;
    --json) JSON_OUT=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) log_error "Unknown: $1"; usage; exit 2 ;;
  esac
done

if [[ $DO_GLOBAL -eq 0 && $DO_PROJECT -eq 0 && $DO_RUNTIME -eq 0 && -z "$HOST" ]]; then
  DO_GLOBAL=1
  DO_PROJECT=1
  DO_RUNTIME=1
fi

emit() {
  local status="$1" check="$2" msg="$3" remediation="${4:-}"
  case "$status" in
    FAIL) FAILURES=$((FAILURES + 1)) ;;
    WARN) WARNS=$((WARNS + 1)) ;;
  esac
  if [[ "$JSON_OUT" -eq 1 ]]; then
    printf '{"status":"%s","check":"%s","message":"%s","remediation":"%s"}\n' \
      "$status" "$check" "$msg" "$remediation"
  else
    printf '[%s] %s: %s' "$status" "$check" "$msg"
    [[ -n "$remediation" ]] && printf ' → %s' "$remediation"
    printf '\n'
  fi
}

check_cmd() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    emit OK "$label" "found"
  else
    emit WARN "$label" "not found" "Install per foundational_docs/cursor/INTEGRATION_SEQUENCE.md"
  fi
}

run_global() {
  log_info "Scope: global"
  check_cmd engram_binary command -v engram
  check_cmd context_mode command -v context-mode
  check_cmd ai_first bash -c 'command -v af || command -v npx'
  check_cmd graphify bash -c 'command -v graphify || command -v graphifyy'
  if command -v node >/dev/null 2>&1; then
    major="$(node -v | sed 's/v//' | cut -d. -f1)"
    if [[ "$major" -ge 18 ]]; then
      emit OK node_version "node $(node -v)"
    else
      emit WARN node_version "node < 18" "Upgrade Node for Agent Smith"
    fi
  else
    emit WARN node_version "node not found" "Install Node >= 18 for Agent Smith"
  fi
}

host_config_paths() {
  local h="$1"
  case "$h" in
    cursor)
      echo "${HOME}/.cursor/mcp.json"
      ;;
    opencode)
      echo "${HOME}/.config/opencode/opencode.json"
      echo "${HOME}/.config/opencode/mcp.json"
      ;;
    vscode-copilot)
      echo "${HOME}/.vscode/mcp.json"
      ;;
    *)
      echo ""
      ;;
  esac
}

run_host() {
  local h="${1:-}"
  if [[ -z "$h" ]]; then
    if [[ -f .ai_engineer_toolkit/host.primary ]]; then
      h="$(tr -d '[:space:]' < .ai_engineer_toolkit/host.primary)"
    else
      emit SKIP host "no --host and no .ai_engineer_toolkit/host.primary"
      return
    fi
  fi
  log_info "Scope: host ($h)"
  local found=0
  local p
  while IFS= read -r p; do
    [[ -z "$p" ]] && continue
    if [[ -f "$p" ]]; then
      if grep -qi engram "$p" 2>/dev/null; then
        emit OK mcp_engram_registered "engram in $p"
        found=1
      fi
    fi
  done < <(host_config_paths "$h")
  if [[ $found -eq 0 ]]; then
    emit WARN mcp_engram_registered "not found in host config" "Run: engram setup $h"
  fi
  if [[ "$h" == "opencode" ]]; then
  if [[ -f "${HOME}/.config/opencode/opencode.json" ]] && grep -qi router "${HOME}/.config/opencode/opencode.json" 2>/dev/null; then
      emit OK model_router_plugin "router referenced in opencode.json"
    else
      emit WARN model_router_plugin "not detected" "Install OpenCode Model Router plugin"
    fi
  fi
}

run_project() {
  log_info "Scope: project (cwd: $(pwd))"
  if [[ -f AGENTS.md ]]; then
    emit OK agents_md "present"
  else
    emit FAIL agents_md "missing" "Run: scripts/install-toolkit.sh bind --local ."
  fi
  if [[ -d .ai_engineer_toolkit ]]; then
    emit OK ai_engineer_toolkit_dir "present"
  else
    emit FAIL ai_engineer_toolkit_dir "missing" "Run: scripts/install-toolkit.sh bind --local ."
  fi
  if [[ -f .ai_engineer_toolkit/model_router_tiers.logical.json ]]; then
    emit OK logical_tiers "present"
  else
    emit WARN logical_tiers "missing" "Re-run bind from toolkit >= 0.1.0"
  fi
  if [[ -f .ai_engineer_toolkit/capability_profile.yaml ]]; then
    emit OK capability_profile "present"
  else
    emit WARN capability_profile "missing" "Copy from capability_profile.template.yaml"
  fi
  if [[ -d ai-context ]]; then
    emit OK ai_context "ai-context/ exists"
  else
    emit WARN ai_context_fresh "ai-context/ missing" "Run: af init"
  fi
  if [[ -d .engram ]]; then
    emit OK engram_data_dir ".engram/ exists"
  else
    emit WARN engram_data_dir ".engram/ missing" "Created on first Engram use or set ENGRAM_DATA_DIR"
  fi
  if [[ -f .github/copilot-instructions.md ]]; then
    emit OK copilot_instructions "present"
  else
    emit WARN copilot_instructions "missing" "Optional: npx agentsmith assimilate ."
  fi
}

run_runtime() {
  log_info "Scope: runtime"
  emit SKIP mcp_engram_ping "MCP started by IDE — not probed in v0.1"
  emit SKIP tier_candidates_resolve "requires active host session"
}

[[ $DO_GLOBAL -eq 1 ]] && run_global
[[ -n "$HOST" || $DO_PROJECT -eq 1 ]] && { [[ -n "$HOST" ]] && run_host "$HOST"; }
[[ $DO_PROJECT -eq 1 ]] && run_project
[[ $DO_RUNTIME -eq 1 ]] && run_runtime

if [[ $DO_PROJECT -eq 1 && -z "$HOST" ]]; then
  run_host ""
fi

if [[ $FAILURES -gt 0 ]]; then
  exit 1
fi
exit 0
