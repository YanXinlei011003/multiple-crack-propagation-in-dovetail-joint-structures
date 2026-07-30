#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <archive-name.zip> [asset-directory]" >&2
  exit 2
fi

archive_name=$1
asset_directory=${2:-.}
output_path="${asset_directory%/}/${archive_name}"

shopt -s nullglob
parts=("${asset_directory%/}/${archive_name}".part*)
shopt -u nullglob

if [[ ${#parts[@]} -eq 0 ]]; then
  echo "No parts found for ${archive_name} in ${asset_directory}" >&2
  exit 1
fi

if [[ -e "$output_path" ]]; then
  echo "Output already exists: ${output_path}" >&2
  exit 1
fi

cat "${parts[@]}" > "$output_path"
echo "Created: ${output_path}"

if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$output_path"
elif command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "$output_path"
fi
