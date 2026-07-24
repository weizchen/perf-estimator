#map = affine_map<(d0, d1, d2) -> (0, d1, d2)>
#map1 = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
module {
  func.func @kernel(%arg0: tensor<1x1024x320xf32>, %arg1: tensor<1x1024x320xf32>) -> tensor<1x1024x320xf32> {
    %0 = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0,proc : 1> -> tensor<1x1024x320xf32> {
      %1 = linalg.generic {indexing_maps = [#map, #map1], iterator_types = ["parallel", "parallel", "parallel"]} ins(%arg0 : tensor<1x1024x320xf32>) outs(%arg1 : tensor<1x1024x320xf32>) {
      ^bb0(%in: f32, %out: f32):
        linalg.yield %in : f32
      } -> tensor<1x1024x320xf32>
      NAIL.yield %1 : tensor<1x1024x320xf32>
    }
    return %0 : tensor<1x1024x320xf32>
  }
}
