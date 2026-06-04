// The named `linalg.softmax` wrapped in a NAIL.unit on VE (proc:1).
//
// Used to show the named softmax does NOT lower on VE/Scalar — there is no
// softmax kernel, and it strands an unrealized_conversion_cast:
//
//   ofa-compiler softmax_wrapped_named.mlir --target-spec=<Fuji-NPU.json> \
//     --scheduling --dispatch-resource-alloc=1 --resource-alloc=1 \
//     --emit-stage=llvm-ir
//   -> error: ... could not lower / unrealized_conversion_cast
//
// (Set proc:0 instead of proc:1 to try Scalar — same result.)

module {
  func.func @main(%a: tensor<8x16xf32>, %o: tensor<8x16xf32>) -> tensor<8x16xf32> {
    %r = NAIL.unit {schedule = 0 : i64}
           : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<8x16xf32> {
      %0 = linalg.softmax dimension(1)
             ins(%a : tensor<8x16xf32>) outs(%o : tensor<8x16xf32>) -> tensor<8x16xf32>
      NAIL.yield %0 : tensor<8x16xf32>
    }
    return %r : tensor<8x16xf32>
  }
}
