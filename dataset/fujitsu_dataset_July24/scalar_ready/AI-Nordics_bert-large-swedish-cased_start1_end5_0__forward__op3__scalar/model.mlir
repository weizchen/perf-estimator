#map = affine_map<(d0, d1, d2, d3) -> (0, 0, 0, d3)>
#map1 = affine_map<(d0, d1, d2, d3) -> (d0, d1, d2, d3)>
module {
  func.func @kernel(%arg0: tensor<1x1x1x512xf32>, %arg1: tensor<1x1x1x512xf32>) -> tensor<1x1x1x512xf32> {
    %0 = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0,proc : 0> -> tensor<1x1x1x512xf32> {
      %cst = arith.constant -3.40282347E+38 : f32
      %1 = linalg.generic {indexing_maps = [#map, #map1], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%arg0 : tensor<1x1x1x512xf32>) outs(%arg1 : tensor<1x1x1x512xf32>) {
      ^bb0(%in: f32, %out: f32):
        %2 = arith.mulf %in, %cst : f32
        linalg.yield %2 : f32
      } -> tensor<1x1x1x512xf32>
      NAIL.yield %1 : tensor<1x1x1x512xf32>
    }
    return %0 : tensor<1x1x1x512xf32>
  }
}
