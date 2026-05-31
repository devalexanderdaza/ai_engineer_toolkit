#!/usr/bin/env bash
# Shared helpers for AI Engineer Toolkit scripts.

set -euo pipefail

AI_TOOLKIT_REPO="${AI_TOOLKIT_REPO:-devalexanderdaza/ai_engineer_toolkit}"
AI_TOOLKIT_REF="${AI_TOOLKIT_REF:-develop}"
RAW_BASE="https://raw.githubusercontent.com/${AI_TOOLKIT_REPO}/${AI_TOOLKIT_REF}"

# Resolve toolkit root from caller script location if not set.
resolve_toolkit_root() {
  if [[ -n "${TOOLKIT_ROOT:-}" && -d "${TOOLKIT_ROOT}/project_templates" ]]; then
    export REMOTE_ONLY=0
    return 0
  fi
  local script_dir="${1:-}"
  if [[ -n "$script_dir" && "$(basename "$script_dir")" == "scripts" ]]; then
    TOOLKIT_ROOT="$(cd "$script_dir/.." && pwd)"
  elif [[ -n "$script_dir" && "$(basename "$script_dir")" == "lib" ]]; then
    TOOLKIT_ROOT="$(cd "$script_dir/../.." && pwd)"
  elif [[ -n "$script_dir" ]]; then
    TOOLKIT_ROOT="$(cd "$script_dir" && pwd)"
  else
    TOOLKIT_ROOT="$(pwd)"
  fi
  if [[ -d "${TOOLKIT_ROOT}/project_templates" ]]; then
    export REMOTE_ONLY=0
    export TOOLKIT_ROOT
    return 0
  fi
  # Piped install (curl | bash): fetch from GitHub raw
  export REMOTE_ONLY=1
  TOOLKIT_ROOT="${TOOLKIT_CACHE:-$(mktemp -d -t ai-toolkit-XXXXXX)}"
  export TOOLKIT_ROOT
  mkdir -p "${TOOLKIT_ROOT}/install" "${TOOLKIT_ROOT}/project_templates"
  fetch_remote_file "install/files.manifest" "${TOOLKIT_ROOT}/install/files.manifest" || true
  fetch_remote_file "VERSION" "${TOOLKIT_ROOT}/VERSION" 2>/dev/null || echo "${AI_TOOLKIT_REF}" > "${TOOLKIT_ROOT}/VERSION"
}

log_info()  { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
log_warn()  { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
log_error() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; }

read_toolkit_version() {
  local vf="${TOOLKIT_ROOT}/VERSION"
  if [[ -f "$vf" ]]; then
    tr -d '[:space:]' < "$vf"
  else
    echo "unknown"
  fi
}

read_files_manifest() {
  local manifest="${TOOLKIT_ROOT}/install/files.manifest"
  if [[ ! -f "$manifest" ]]; then
    if [[ "${REMOTE_ONLY:-0}" -eq 1 ]]; then
      fetch_remote_file "install/files.manifest" "$manifest"
    else
      log_error "Missing install/files.manifest at $manifest"
      return 1
    fi
  fi
  grep -v '^[[:space:]]*#' "$manifest" | grep -v '^[[:space:]]*$' || true
}

fetch_remote_file() {
  local rel_path="$1"
  local dest="$2"
  local url="${RAW_BASE}/${rel_path}"
  mkdir -p "$(dirname "$dest")"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$dest"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$url"
  else
    log_error "curl or wget required for remote install"
    return 1
  fi
}

get_template_source() {
  local filename="$1"
  local local_path="${TOOLKIT_ROOT}/project_templates/${filename}"
  if [[ -f "$local_path" && "${REMOTE_ONLY:-0}" -eq 0 ]]; then
    echo "$local_path"
    return 0
  fi
  if [[ ! -f "$local_path" ]]; then
    fetch_remote_file "project_templates/${filename}" "$local_path"
  fi
  echo "$local_path"
}

apply_placeholders() {
  local src="$1"
  local dest="$2"
  local project_name="${3:-.}"
  sed "s/{{project_name}}/${project_name}/g" "$src" > "$dest"
}

is_fresh_install() {
  local target_dir="$1"
  local version_file="${target_dir}/.ai_engineer_toolkit/.toolkit-version"
  local current
  current="$(read_toolkit_version)"
  if [[ -f "$version_file" ]] && [[ "$(tr -d '[:space:]' < "$version_file")" == "$current" ]]; then
    return 0
  fi
  return 1
}

write_toolkit_version_stamp() {
  local target_dir="$1"
  mkdir -p "${target_dir}/.ai_engineer_toolkit"
  read_toolkit_version > "${target_dir}/.ai_engineer_toolkit/.toolkit-version"
}
