#map = affine_map<(d0, d1, d2) -> (d0, d1)>
#map1 = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
module {
  func.func @kernel(%arg0: tensor<1x64xi64>, %arg1: tensor<1x64x768xf32>, %arg2: tensor<514x768xf32>) -> tensor<1x64x768xf32> {
    %0 = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0,proc : 1> -> tensor<1x64x768xf32> {
      %c514 = arith.constant 514 : index
      %c0_i64 = arith.constant 0 : i64
      %1 = linalg.generic {indexing_maps = [#map, #map1], iterator_types = ["parallel", "parallel", "parallel"]} ins(%arg0 : tensor<1x64xi64>) outs(%arg1 : tensor<1x64x768xf32>) {
      ^bb0(%in: i64, %out: f32):
        %2 = arith.index_cast %in : i64 to index
        %3 = linalg.index 2 : index
        %4 = arith.cmpi slt, %2, %c514 : index
        cf.assert %4, "index must be smaller than dim size"
        %5 = arith.cmpi sge, %in, %c0_i64 : i64
        cf.assert %5, "index must be larger or equal to 0"
        %extracted = tensor.extract %arg2[%2, %3] : tensor<514x768xf32>
        linalg.yield %extracted : f32
      } -> tensor<1x64x768xf32>
      NAIL.yield %1 : tensor<1x64x768xf32>
    }
    return %0 : tensor<1x64x768xf32>
  }
}
