module {
  func.func @kernel(%arg0: tensor<1141xf32>, %arg1: tensor<f32>) -> tensor<f32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<f32> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%arg0 : tensor<1141xf32>) outs(%arg1 : tensor<f32>) {
    ^bb0(%in: f32, %out: f32):
      %0 = arith.maximumf %in, %out : f32
      linalg.yield %0 : f32
    } -> tensor<f32>
      NAIL.yield %g : tensor<f32>
    }
    return %r : tensor<f32>
  }
}
