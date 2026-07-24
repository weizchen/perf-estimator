#map = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
#map1 = affine_map<(d0, d1, d2) -> (d0, d1, 0)>
module {
  func.func @kernel(%arg0: tensor<1x256x256xf32>, %arg1: tensor<1x256x1xf32>) -> tensor<1x256x1xf32> {
    %0 = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0,proc : 0> -> tensor<1x256x1xf32> {
      %1 = linalg.generic {indexing_maps = [#map, #map1], iterator_types = ["parallel", "parallel", "reduction"]} ins(%arg0 : tensor<1x256x256xf32>) outs(%arg1 : tensor<1x256x1xf32>) {
      ^bb0(%in: f32, %out: f32):
        %2 = arith.addf %in, %out : f32
        linalg.yield %2 : f32
      } -> tensor<1x256x1xf32>
      NAIL.yield %1 : tensor<1x256x1xf32>
    }
    return %0 : tensor<1x256x1xf32>
  }
}
