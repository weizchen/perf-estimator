#map = affine_map<(d0, d1, d2) -> (0, d1, 0)>
#map1 = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
module {
  func.func @kernel(%arg0: tensor<1x256x1xf32>, %arg1: tensor<1x256x1xf32>) -> tensor<1x256x1xf32> {
    %0 = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0,proc : 0> -> tensor<1x256x1xf32> {
      %cst = arith.constant 1.000000e-05 : f64
      %1 = linalg.generic {indexing_maps = [#map, #map1], iterator_types = ["parallel", "parallel", "parallel"]} ins(%arg0 : tensor<1x256x1xf32>) outs(%arg1 : tensor<1x256x1xf32>) {
      ^bb0(%in: f32, %out: f32):
        %2 = arith.truncf %cst : f64 to f32
        %3 = arith.addf %in, %2 : f32
        linalg.yield %3 : f32
      } -> tensor<1x256x1xf32>
      NAIL.yield %1 : tensor<1x256x1xf32>
    }
    return %0 : tensor<1x256x1xf32>
  }
}
