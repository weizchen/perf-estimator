module {
  func.func @kernel(%arg0: tensor<4419xbf16>, %arg1: tensor<4419xbf16>) -> tensor<4419xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<4419xbf16> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<4419xbf16>) outs(%arg1 : tensor<4419xbf16>) {
    ^bb0(%in: bf16, %out: bf16):
      %c1 = arith.constant 1.0 : bf16
      %0 = arith.divf %c1, %in : bf16
      linalg.yield %0 : bf16
    } -> tensor<4419xbf16>
      NAIL.yield %g : tensor<4419xbf16>
    }
    return %r : tensor<4419xbf16>
  }
}
