#!/usr/bin/env bash
# Brownfield init — Phases 0-2 (bind project files; global/host steps are documented, not auto-installed).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'EOF'
Usage: init-brownfield.sh [--host HOST] [--local] [--skip-if-fresh] [TARGET_DIR]

Runs:
  Phase 2 (project bind): install-toolkit.sh bind
  Then prints Phase 0-1 commands for manual/global setup (idempotent).

Does NOT: reinstall global binaries, run "engram mcp &", or auto-run af init.
EOF
}

HOST=""
USE_LOCAL=0
SKIP_IF_FRESH=0
TARGET="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) HOST="${2:-}"; shift 2 ;;
    --local) USE_LOCAL=1; shift ;;
    --skip-if-fresh) SKIP_IF_FRESH=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) TARGET="$1"; shift ;;
  esac
done

resolve_toolkit_root "$SCRIPT_DIR"
TARGET="$(cd "$TARGET" && pwd)"

BIND_ARGS=(bind)
[[ -n "$HOST" ]] && BIND_ARGS+=(--host "$HOST")
[[ $USE_LOCAL -eq 1 ]] && BIND_ARGS+=(--local)
[[ $SKIP_IF_FRESH -eq 1 ]] && BIND_ARGS+=(--skip-if-fresh)
BIND_ARGS+=("$TARGET")

log_info "Phase 2: project bind"
"${SCRIPT_DIR}/install-toolkit.sh" "${BIND_ARGS[@]}"

log_info ""
log_info "Phase 0 (global) — run once per machine:"
log_info "  ./scripts/doctor.sh --global"
log_info "  Install: engram, context-mode, af (AI-First), graphify — see INTEGRATION_SEQUENCE.md"
log_info ""
log_info "Phase 1 (host bind) — per IDE:"
H="${HOST:-<your-host>}"
log_info "  engram setup $H"
log_info "  af mcp install --profile $H   # or cursor/opencode variant"
log_info "  graphify install --platform $H"
log_info "  context-mode $H install       # if using Context Mode"
log_info ""
log_info "Phase 2 (continued) — in project:"
log_info "  cd $TARGET && af init"
log_info "  graphify . --project"
log_info "  npx agentsmith assimilate .   # optional, Copilot/VS Code"
log_info ""
log_info "Phase 3: restart IDE — MCP starts automatically"
log_info ""
"${SCRIPT_DIR}/doctor.sh" --project || true
