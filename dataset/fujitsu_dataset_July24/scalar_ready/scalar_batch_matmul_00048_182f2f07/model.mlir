module {
  func.func @kernel(%arg0: tensor<4x384x384xf16>, %arg1: tensor<4x384x128xf16>, %arg2: tensor<4x384x128xf32>) -> tensor<4x384x128xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x384x128xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<4x384x384xf16>, tensor<4x384x128xf16>) outs(%arg2 : tensor<4x384x128xf32>) -> tensor<4x384x128xf32>
      NAIL.yield %z : tensor<4x384x128xf32>
    }
    return %r : tensor<4x384x128xf32>
  }
}
