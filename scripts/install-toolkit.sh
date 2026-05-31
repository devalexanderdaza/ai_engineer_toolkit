#!/usr/bin/env bash
# AI Engineer Toolkit — install/bind without cloning the full repo (remote) or from local clone.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'EOF'
Usage:
  install-toolkit.sh bind [--host HOST] [--local] [--dry-run] [--skip-if-fresh] [TARGET_DIR]
  install-toolkit.sh greenfield PROJECT_NAME [--host HOST] [--local] [--dry-run]

Options:
  --host HOST         Primary IDE host (cursor, opencode, vscode-copilot, ...)
  --local             Use files from this toolkit clone (default if project_templates exists)
  --dry-run           Print actions without writing files
  --skip-if-fresh     Skip if .ai_engineer_toolkit/.toolkit-version matches toolkit VERSION

Environment:
  AI_TOOLKIT_REPO     GitHub repo (default: devalexanderdaza/ai_engineer_toolkit)
  AI_TOOLKIT_REF      Branch/tag/SHA (default: develop)
  TOOLKIT_ROOT        Path to toolkit clone (auto-detected)

Examples:
  ./scripts/install-toolkit.sh bind --local --host cursor .
  curl -fsSL "https://raw.githubusercontent.com/devalexanderdaza/ai_engineer_toolkit/develop/scripts/install-toolkit.sh" | bash -s -- bind --host cursor .
EOF
}

MODE=""
PROJECT_NAME=""
TARGET_DIR="."
HOST=""
USE_LOCAL=0
DRY_RUN=0
SKIP_IF_FRESH=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    bind|greenfield) MODE="$1"; shift ;;
    --host) HOST="${2:-}"; shift 2 ;;
    --local) USE_LOCAL=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    --skip-if-fresh) SKIP_IF_FRESH=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) log_error "Unknown option: $1"; usage; exit 2 ;;
    *)
      if [[ "$MODE" == "greenfield" && -z "$PROJECT_NAME" ]]; then
        PROJECT_NAME="$1"
      else
        TARGET_DIR="$1"
      fi
      shift
      ;;
  esac
done

if [[ -z "$MODE" ]]; then
  usage
  exit 2
fi

resolve_toolkit_root "$SCRIPT_DIR"

if [[ -d "${TOOLKIT_ROOT}/project_templates" ]]; then
  USE_LOCAL=1
fi

if [[ "$MODE" == "greenfield" ]]; then
  if [[ -z "$PROJECT_NAME" ]]; then
    log_error "greenfield requires PROJECT_NAME"
    exit 2
  fi
  parent="${TARGET_DIR}"
  if [[ "$parent" == "." ]]; then
    parent="$(pwd)"
  else
    parent="$(cd "$parent" && pwd)"
  fi
  TARGET_DIR="${parent}/${PROJECT_NAME}"
  if [[ -e "$TARGET_DIR" ]]; then
    log_error "Directory already exists: $TARGET_DIR"
    exit 1
  fi
  if [[ "$DRY_RUN" -eq 0 ]]; then
    mkdir -p "$TARGET_DIR"
    printf '# %s\n\nProyecto inicializado con AI Engineer Toolkit.\n' "$PROJECT_NAME" > "${TARGET_DIR}/README.md"
  else
    log_info "[dry-run] would mkdir $TARGET_DIR"
  fi
fi

TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")"
PROJECT_LABEL="$(basename "$TARGET_DIR")"

if [[ "$SKIP_IF_FRESH" -eq 1 ]] && is_fresh_install "$TARGET_DIR"; then
  log_info "Skip: .ai_engineer_toolkit already at toolkit version $(read_toolkit_version)"
  exit 0
fi

TOOLKIT_DIR="${TARGET_DIR}/.ai_engineer_toolkit"
AGENTS_DEST="${TARGET_DIR}/AGENTS.md"

if [[ "$DRY_RUN" -eq 1 ]]; then
  log_info "[dry-run] bind -> ${TOOLKIT_DIR}/"
  while IFS= read -r f; do
    [[ -n "$f" ]] && log_info "[dry-run]   copy $f"
  done < <(read_files_manifest)
  log_info "[dry-run]   AGENTS.md from AGENTS.template.md"
  if [[ -n "$HOST" ]]; then
    log_info "[dry-run]   write .ai_engineer_toolkit/host.primary = $HOST"
  fi
  exit 0
fi

mkdir -p "$TOOLKIT_DIR"
TMP_CLEAN=()

cleanup_tmp() {
  for t in "${TMP_CLEAN[@]:-}"; do
    [[ -f "$t" ]] && rm -f "$t"
  done
}
trap cleanup_tmp EXIT

while IFS= read -r filename; do
  [[ -z "$filename" ]] && continue
  src="$(get_template_source "$filename")"
  if [[ "$src" != "${TOOLKIT_ROOT}/project_templates/${filename}" ]]; then
    TMP_CLEAN+=("$src")
  fi
  dest_name="$filename"
  if [[ "$filename" == "AGENTS.template.md" ]]; then
    continue
  fi
  if [[ "$filename" == "capability_profile.template.yaml" ]]; then
    dest_name="capability_profile.yaml"
  fi
  if [[ "$filename" == *.template.* ]]; then
    dest_name="${filename/.template/}"
  fi
  if [[ "$src" == *"AGENTS"* ]] || [[ "$filename" == "capability_profile.template.yaml" ]]; then
    apply_placeholders "$src" "${TOOLKIT_DIR}/${dest_name}" "$PROJECT_LABEL"
  else
    cp "$src" "${TOOLKIT_DIR}/${dest_name}"
  fi
done < <(read_files_manifest)

# AGENTS.md at project root
agents_src="$(get_template_source "AGENTS.template.md")"
if [[ "$agents_src" != "${TOOLKIT_ROOT}/project_templates/AGENTS.template.md" ]]; then
  TMP_CLEAN+=("$agents_src")
fi
apply_placeholders "$agents_src" "$AGENTS_DEST" "$PROJECT_LABEL"

if [[ -n "$HOST" ]]; then
  echo "$HOST" > "${TOOLKIT_DIR}/host.primary"
fi

write_toolkit_version_stamp "$TARGET_DIR"

log_info "Bound AI Engineer Toolkit to: $TARGET_DIR"
log_info "  .ai_engineer_toolkit/ ($(read_toolkit_version))"
log_info "  AGENTS.md"
log_info ""
log_info "Next steps:"
log_info "  1. Global tools:  ./scripts/doctor.sh --global"
log_info "  2. Host bind:     engram setup ${HOST:-<host>}; af mcp install; graphify install --platform <host>"
log_info "  3. Project:       af init; optional: npx agentsmith assimilate ."
log_info "  Docs: foundational_docs/cursor/ (or .ai_engineer_toolkit/toolkit.manifest.yaml)"
