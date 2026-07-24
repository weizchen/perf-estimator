module {
  func.func @kernel(%arg0: tensor<640x2112xbf16>, %arg1: tensor<2112x1280xbf16>, %arg2: tensor<640x1280xf32>) -> tensor<640x1280xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<640x1280xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<640x2112xbf16>, tensor<2112x1280xbf16>) outs(%arg2 : tensor<640x1280xf32>) -> tensor<640x1280xf32>
      NAIL.yield %m : tensor<640x1280xf32>
    }
    return %r : tensor<640x1280xf32>
  }
}
