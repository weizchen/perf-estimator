module {
  func.func @kernel(%arg0: tensor<960x1472xf16>, %arg1: tensor<1472x512xf16>, %arg2: tensor<960x512xf32>) -> tensor<960x512xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<960x512xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<960x1472xf16>, tensor<1472x512xf16>) outs(%arg2 : tensor<960x512xf32>) -> tensor<960x512xf32>
      NAIL.yield %m : tensor<960x512xf32>
    }
    return %r : tensor<960x512xf32>
  }
}
