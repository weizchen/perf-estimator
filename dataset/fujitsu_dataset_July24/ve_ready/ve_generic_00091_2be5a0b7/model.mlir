module {
  func.func @kernel(%arg0: tensor<3818xf16>, %arg1: tensor<3818xf16>) -> tensor<3818xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3818xf16> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<3818xf16>) outs(%arg1 : tensor<3818xf16>) {
    ^bb0(%in: f16, %out: f16):
      %0 = arith.addf %in, %out : f16
      %1 = arith.mulf %in, %0 : f16
      %2 = arith.addf %in, %1 : f16
      %3 = arith.mulf %in, %2 : f16
      linalg.yield %3 : f16
    } -> tensor<3818xf16>
      NAIL.yield %g : tensor<3818xf16>
    }
    return %r : tensor<3818xf16>
  }
}
