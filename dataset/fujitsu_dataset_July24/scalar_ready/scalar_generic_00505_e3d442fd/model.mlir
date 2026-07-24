module {
  func.func @kernel(%arg0: tensor<716xf16>, %arg1: tensor<f16>) -> tensor<f16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<f16> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%arg0 : tensor<716xf16>) outs(%arg1 : tensor<f16>) {
    ^bb0(%in: f16, %out: f16):
      %0 = arith.addf %in, %out : f16
      linalg.yield %0 : f16
    } -> tensor<f16>
      NAIL.yield %g : tensor<f16>
    }
    return %r : tensor<f16>
  }
}
