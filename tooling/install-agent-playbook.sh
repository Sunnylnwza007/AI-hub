#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf '%s\n' \
    'Usage: tooling/install-agent-playbook.sh --target <project-path> [--check]' \
    '       tooling/install-agent-playbook.sh --help'
}

target=''
check_only=false

while (($# > 0)); do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || { printf '%s\n' '--target requires a path' >&2; exit 2; }
      target=$2
      shift 2
      ;;
    --check)
      check_only=true
      shift
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ -n "$target" ]] || { usage >&2; exit 2; }
[[ -d "$target" ]] || { printf 'Target directory does not exist: %s\n' "$target" >&2; exit 1; }

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
target=$(cd -- "$target" && pwd)
package_dir="$target/.ai-agent-playbook"

required_sources=(
  "$repo_root/docs/agent-roles.md"
  "$repo_root/docs/ai-agent-operating-playbook.md"
  "$repo_root/docs/installation.md"
  "$repo_root/install/manifest.yaml"
)

for source in "${required_sources[@]}"; do
  [[ -f "$source" ]] || { printf 'Missing package artifact: %s\n' "$source" >&2; exit 1; }
done

required_targets=(
  "$package_dir/docs/agent-roles.md"
  "$package_dir/docs/ai-agent-operating-playbook.md"
  "$package_dir/docs/installation.md"
  "$package_dir/install/manifest.yaml"
)

if "$check_only"; then
  for file in "${required_targets[@]}"; do
    [[ -f "$file" ]] || { printf 'Missing installed artifact: %s\n' "$file" >&2; exit 1; }
  done
  printf '%s\n' '[OK] AI agent playbook installation is complete'
  exit 0
fi

mkdir -p "$package_dir/docs" "$package_dir/install"
cp "$repo_root/docs/agent-roles.md" "$package_dir/docs/agent-roles.md"
cp "$repo_root/docs/ai-agent-operating-playbook.md" "$package_dir/docs/ai-agent-operating-playbook.md"
cp "$repo_root/docs/installation.md" "$package_dir/docs/installation.md"
cp "$repo_root/install/manifest.yaml" "$package_dir/install/manifest.yaml"

for adapter in AGENTS.md CLAUDE.md GEMINI.md; do
  adapter_path="$target/$adapter"
  pointer='Read .ai-agent-playbook/docs/ai-agent-operating-playbook.md before agent work; use it with .ai-agent-playbook/docs/agent-roles.md for coordination, routing and handoff.'
  if [[ -f "$adapter_path" ]]; then
    grep -Fqx "$pointer" "$adapter_path" || printf '\n%s\n' "$pointer" >> "$adapter_path"
  else
    printf '%s\n' "# Agent instructions" '' "$pointer" > "$adapter_path"
  fi
done

printf '%s\n' '[OK] AI agent playbook installed'
