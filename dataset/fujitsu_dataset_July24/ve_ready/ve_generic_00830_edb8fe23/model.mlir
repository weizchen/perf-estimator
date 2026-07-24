module {
  func.func @kernel(%arg0: tensor<26xbf16>, %arg1: tensor<26xbf16>) -> tensor<26xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<26xbf16> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<26xbf16>) outs(%arg1 : tensor<26xbf16>) {
    ^bb0(%in: bf16, %out: bf16):
      %0 = arith.mulf %in, %out : bf16
      %1 = arith.addf %in, %0 : bf16
      %2 = arith.mulf %in, %1 : bf16
      %3 = arith.addf %in, %2 : bf16
      %4 = arith.maximumf %in, %3 : bf16
      linalg.yield %4 : bf16
    } -> tensor<26xbf16>
      NAIL.yield %g : tensor<26xbf16>
    }
    return %r : tensor<26xbf16>
  }
}
