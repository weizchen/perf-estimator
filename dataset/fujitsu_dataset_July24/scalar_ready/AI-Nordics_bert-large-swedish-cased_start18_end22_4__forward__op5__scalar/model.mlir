#map = affine_map<(d0, d1, d2) -> (0, d1, d2)>
#map1 = affine_map<(d0, d1, d2) -> (d2)>
#map2 = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
module {
  func.func @kernel(%arg0: tensor<1x512x1024xf32>, %arg1: tensor<1024xf32>, %arg2: tensor<1x512x1024xf32>) -> tensor<1x512x1024xf32> {
    %0 = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0,proc : 0> -> tensor<1x512x1024xf32> {
      %1 = linalg.generic {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "parallel"]} ins(%arg0, %arg1 : tensor<1x512x1024xf32>, tensor<1024xf32>) outs(%arg2 : tensor<1x512x1024xf32>) {
      ^bb0(%in: f32, %in_0: f32, %out: f32):
        %2 = arith.addf %in, %in_0 : f32
        linalg.yield %2 : f32
      } -> tensor<1x512x1024xf32>
      NAIL.yield %1 : tensor<1x512x1024xf32>
    }
    return %0 : tensor<1x512x1024xf32>
  }
}
