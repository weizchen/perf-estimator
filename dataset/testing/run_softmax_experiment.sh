#!/usr/bin/env bash
# Experiment: can `linalg.softmax` be made lowerable to VE/Scalar?
#
# Answer (reproduced by the four steps below):
#   1. --linalg-generalize-named-ops is a NO-OP on softmax (aggregate op).
#   2. The named softmax does NOT lower on VE/Scalar (no kernel).
#   3. The transform-dialect `decompose_interface` DOES expand it into
#      reduction/elementwise generics (max-reduce, exp(x-max), sum-reduce, div),
#      each of which lowers on VE/Scalar.
#   4. But the decomposed sequence is multi-op, and a NAIL.unit must hold
#      exactly one compute op -> it cannot be a single-op benchmark.
#
# Tools are resolved relative to this repo; override with $OFA_ROOT if needed.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OFA="${OFA_ROOT:-$HERE/../../../OFA-compiler-master}"
OPT="$OFA/build/bin/ofa-opt"
COMPILER="$OFA/build/bin/ofa-compiler"
MLIR_OPT="$OFA/externals/llvm-project/build/bin/mlir-opt"
TS="$OFA/targets/Fuji-NPU.json"
CARGS=(--target-spec="$TS" --scheduling --dispatch-resource-alloc=1
       --resource-alloc=1 --emit-stage=llvm-ir)
PY="${PYTHON:-python3}"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

for t in "$OPT" "$COMPILER" "$MLIR_OPT"; do
  [[ -x "$t" ]] || { echo "missing tool: $t (build OFA, or set OFA_ROOT)"; exit 1; }
done

echo "### 1. generalize the named softmax (ofa-opt --linalg-generalize-named-ops)"
"$OPT" "$HERE/softmax.mlir" --linalg-generalize-named-ops -o "$TMP/gen.mlir" 2>/dev/null
echo "    ops: $(grep -oE 'linalg\.[a-z_]+' "$TMP/gen.mlir" | sort -u | tr '\n' ' ')"
echo "    => unchanged: generalize is a NO-OP on softmax."
echo

echo "### 2. does the NAMED softmax lower on VE? (ofa-compiler)"
echo -n "    "
"$COMPILER" "$HERE/softmax_wrapped_named.mlir" "${CARGS[@]}" -o /dev/null 2>&1 \
  | grep -ioE "could not lower[^.]*|unrealized_conversion_cast|Compilation successful" | head -1
echo "    => named softmax has no VE/Scalar kernel."
echo

echo "### 3. decompose softmax via the transform dialect (mlir-opt --transform-interpreter)"
"$MLIR_OPT" "$HERE/softmax_decompose.mlir" --transform-interpreter -o "$TMP/dec.mlir" 2>/dev/null
echo "    decomposed func body ops:"
sed -n '/func.func @main/,/return/p' "$TMP/dec.mlir" \
  | grep -oE 'linalg\.[a-z_]+|tensor\.[a-z_]+|math\.[a-z]+' | sort | uniq -c | sed 's/^/      /'
echo "    => softmax -> reductions + exp + div + fills (all VE/Scalar-lowerable)."
echo

echo "### 4. wrap the decomposed sequence in ONE NAIL.unit and compile on Scalar"
"$PY" - "$TMP/dec.mlir" "$TMP/wrapped.mlir" <<'PYEOF'
import re, sys
txt = open(sys.argv[1]).read()
maps = "\n".join(l for l in txt.splitlines() if l.strip().startswith("#map"))
body, ret, inside = [], "%0", False
for l in txt.splitlines():
    if "func.func @main" in l:
        inside = True
        continue
    if inside:
        m = re.match(r"\s*return (%\w+)", l)
        if m:
            ret = m.group(1)
            break
        body.append(l)
open(sys.argv[2], "w").write(f"""{maps}
module {{
  func.func @main(%arg0: tensor<8x16xf32>, %arg1: tensor<8x16xf32>) -> tensor<8x16xf32> {{
    %r = NAIL.unit {{schedule = 0 : i64}} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<8x16xf32> {{
{chr(10).join('    ' + l for l in body)}
      NAIL.yield {ret} : tensor<8x16xf32>
    }}
    return %r : tensor<8x16xf32>
  }}
}}
""")
PYEOF
echo -n "    "
"$COMPILER" "$TMP/wrapped.mlir" "${CARGS[@]}" -o /dev/null 2>&1 \
  | grep -ioE "expects exactly one compute op[^.]*|Compilation successful" | head -1
echo "    => a NAIL.unit must hold exactly ONE compute op; softmax can't be a single-op benchmark."
