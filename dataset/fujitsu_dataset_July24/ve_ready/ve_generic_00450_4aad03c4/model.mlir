module {
  func.func @kernel(%arg0: tensor<1669xf32>, %arg1: tensor<1669xf32>) -> tensor<1669xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1669xf32> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<1669xf32>) outs(%arg1 : tensor<1669xf32>) {
    ^bb0(%in: f32, %out: f32):
      %0 = arith.mulf %in, %out : f32
      %1 = arith.addf %in, %0 : f32
      %2 = arith.mulf %in, %1 : f32
      %3 = arith.addf %in, %2 : f32
      %4 = arith.maximumf %in, %3 : f32
      linalg.yield %4 : f32
    } -> tensor<1669xf32>
      NAIL.yield %g : tensor<1669xf32>
    }
    return %r : tensor<1669xf32>
  }
}
