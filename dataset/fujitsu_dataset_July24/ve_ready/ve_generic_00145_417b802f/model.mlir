module {
  func.func @kernel(%arg0: tensor<850xf32>, %arg1: tensor<850xf32>) -> tensor<850xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<850xf32> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<850xf32>) outs(%arg1 : tensor<850xf32>) {
    ^bb0(%in: f32, %out: f32):
      %0 = math.rsqrt %in : f32
      linalg.yield %0 : f32
    } -> tensor<850xf32>
      NAIL.yield %g : tensor<850xf32>
    }
    return %r : tensor<850xf32>
  }
}
