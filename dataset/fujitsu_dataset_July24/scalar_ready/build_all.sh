#!/usr/bin/env bash
# Build the scalar benchmark ELFs for gem5. Builds the RUNNABLE set (top-level
# dirs) by default; unsupported_* subfolders build but currently fail on gem5.
#   ./build_all.sh OFA_ROOT=/path/to/OFA-compiler-master [RISCV_CC=... OBJCOPY=...]
#   INCLUDE_UNSUPPORTED=1 ./build_all.sh OFA_ROOT=...     # also build 
#   JOBS=8 ./build_all.sh OFA_ROOT=...
set -u
here="$(cd "$(dirname "$0")" && pwd)"
export MAKEVARS="$*"
jobs="${JOBS:-$(nproc 2>/dev/null || echo 4)}"
dirs=$(find "$here" -mindepth 1 -maxdepth 1 -type d ! -name 'unsupported_*')
if [ "${INCLUDE_UNSUPPORTED:-0}" = 1 ]; then
  dirs="$dirs
$(find "$here"/unsupported_* -mindepth 1 -maxdepth 1 -type d 2>/dev/null)"
fi
printf '%s\n' $dirs | xargs -P "$jobs" -I{} bash -c '
    d="$1"
    if make -C "$d" elf $MAKEVARS >"$d/build.log" 2>&1; then echo "PASS $(basename "$d")"
    else echo "FAIL $(basename "$d")  ($(tail -n1 "$d/build.log" 2>/dev/null))"; fi' _ {} \
  | tee "$here/build_results.log"
echo "=== $(grep -c '^PASS' "$here/build_results.log") / $(wc -l < "$here/build_results.log") built ==="
