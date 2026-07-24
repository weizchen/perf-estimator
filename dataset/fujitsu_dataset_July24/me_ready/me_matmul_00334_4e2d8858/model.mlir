module {
  func.func @kernel(%arg0: tensor<3968x1280xf16>, %arg1: tensor<1280x3264xf16>, %arg2: tensor<3968x3264xf32>) -> tensor<3968x3264xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<3968x3264xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3968x1280xf16>, tensor<1280x3264xf16>) outs(%arg2 : tensor<3968x3264xf32>) -> tensor<3968x3264xf32>
      NAIL.yield %m : tensor<3968x3264xf32>
    }
    return %r : tensor<3968x3264xf32>
  }
}
