module {
  func.func @kernel(%arg0: tensor<1280x512xf16>, %arg1: tensor<512x2880xf16>, %arg2: tensor<1280x2880xf32>) -> tensor<1280x2880xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1280x2880xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1280x512xf16>, tensor<512x2880xf16>) outs(%arg2 : tensor<1280x2880xf32>) -> tensor<1280x2880xf32>
      NAIL.yield %m : tensor<1280x2880xf32>
    }
    return %r : tensor<1280x2880xf32>
  }
}
