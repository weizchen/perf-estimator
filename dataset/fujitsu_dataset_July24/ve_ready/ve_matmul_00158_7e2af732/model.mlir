module {
  func.func @kernel(%arg0: tensor<3648x640xf16>, %arg1: tensor<640x512xf16>, %arg2: tensor<3648x512xf32>) -> tensor<3648x512xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3648x512xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3648x640xf16>, tensor<640x512xf16>) outs(%arg2 : tensor<3648x512xf32>) -> tensor<3648x512xf32>
      NAIL.yield %m : tensor<3648x512xf32>
    }
    return %r : tensor<3648x512xf32>
  }
}
