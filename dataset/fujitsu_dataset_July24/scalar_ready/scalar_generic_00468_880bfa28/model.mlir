module {
  func.func @kernel(%arg0: tensor<339xf32>, %arg1: tensor<339xf32>) -> tensor<339xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<339xf32> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<339xf32>) outs(%arg1 : tensor<339xf32>) {
    ^bb0(%in: f32, %out: f32):
      %0 = arith.addf %in, %out : f32
      %1 = arith.mulf %in, %0 : f32
      %2 = arith.addf %in, %1 : f32
      %3 = arith.mulf %in, %2 : f32
      %4 = arith.addf %in, %3 : f32
      %5 = arith.mulf %in, %4 : f32
      %6 = arith.addf %in, %5 : f32
      %7 = arith.mulf %in, %6 : f32
      linalg.yield %7 : f32
    } -> tensor<339xf32>
      NAIL.yield %g : tensor<339xf32>
    }
    return %r : tensor<339xf32>
  }
}
