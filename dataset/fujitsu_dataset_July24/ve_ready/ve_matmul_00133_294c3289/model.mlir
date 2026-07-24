module {
  func.func @kernel(%arg0: tensor<64x512xf16>, %arg1: tensor<512x2432xf16>, %arg2: tensor<64x2432xf32>) -> tensor<64x2432xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<64x2432xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<64x512xf16>, tensor<512x2432xf16>) outs(%arg2 : tensor<64x2432xf32>) -> tensor<64x2432xf32>
      NAIL.yield %m : tensor<64x2432xf32>
    }
    return %r : tensor<64x2432xf32>
  }
}
