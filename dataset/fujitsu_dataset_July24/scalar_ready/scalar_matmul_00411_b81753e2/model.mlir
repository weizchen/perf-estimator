module {
  func.func @kernel(%arg0: tensor<64x3392xf32>, %arg1: tensor<3392x704xf32>, %arg2: tensor<64x704xf32>) -> tensor<64x704xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<64x704xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<64x3392xf32>, tensor<3392x704xf32>) outs(%arg2 : tensor<64x704xf32>) -> tensor<64x704xf32>
      NAIL.yield %m : tensor<64x704xf32>
    }
    return %r : tensor<64x704xf32>
  }
}
