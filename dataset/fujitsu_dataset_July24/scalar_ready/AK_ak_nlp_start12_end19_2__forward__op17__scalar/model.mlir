#map = affine_map<(d0, d1, d2, d3) -> (d0, d1, 0, d3)>
#map1 = affine_map<(d0, d1, d2, d3) -> (d0, d1, d2, d3)>
module {
  func.func @kernel(%arg0: tensor<1x1x1x64xi64>, %arg1: tensor<1x1x64x64xi64>) -> tensor<1x1x64x64xi64> {
    %0 = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0,proc : 0> -> tensor<1x1x64x64xi64> {
      %1 = linalg.generic {indexing_maps = [#map, #map1], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%arg0 : tensor<1x1x1x64xi64>) outs(%arg1 : tensor<1x1x64x64xi64>) {
      ^bb0(%in: i64, %out: i64):
        linalg.yield %in : i64
      } -> tensor<1x1x64x64xi64>
      NAIL.yield %1 : tensor<1x1x64x64xi64>
    }
    return %0 : tensor<1x1x64x64xi64>
  }
}
