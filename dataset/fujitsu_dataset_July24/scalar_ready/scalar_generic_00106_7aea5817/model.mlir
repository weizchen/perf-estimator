module {
  func.func @kernel(%arg0: tensor<82xf16>, %arg1: tensor<82xf16>) -> tensor<82xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<82xf16> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<82xf16>) outs(%arg1 : tensor<82xf16>) {
    ^bb0(%in: f16, %out: f16):
      %0 = arith.maximumf %in, %out : f16
      linalg.yield %0 : f16
    } -> tensor<82xf16>
      NAIL.yield %g : tensor<82xf16>
    }
    return %r : tensor<82xf16>
  }
}
