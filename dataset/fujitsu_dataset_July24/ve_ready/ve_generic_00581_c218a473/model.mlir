module {
  func.func @kernel(%arg0: tensor<7376xbf16>, %arg1: tensor<7376xbf16>) -> tensor<7376xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<7376xbf16> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<7376xbf16>) outs(%arg1 : tensor<7376xbf16>) {
    ^bb0(%in: bf16, %out: bf16):
      %0 = arith.addf %in, %out : bf16
      %1 = arith.mulf %in, %0 : bf16
      %2 = arith.addf %in, %1 : bf16
      %3 = arith.mulf %in, %2 : bf16
      %4 = arith.addf %in, %3 : bf16
      %5 = arith.mulf %in, %4 : bf16
      %6 = arith.addf %in, %5 : bf16
      %7 = arith.mulf %in, %6 : bf16
      linalg.yield %7 : bf16
    } -> tensor<7376xbf16>
      NAIL.yield %g : tensor<7376xbf16>
    }
    return %r : tensor<7376xbf16>
  }
}
