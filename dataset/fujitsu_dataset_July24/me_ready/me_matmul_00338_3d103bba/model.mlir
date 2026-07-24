module {
  func.func @kernel(%arg0: tensor<1024x3008xf16>, %arg1: tensor<3008x640xf16>, %arg2: tensor<1024x640xf32>) -> tensor<1024x640xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1024x640xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1024x3008xf16>, tensor<3008x640xf16>) outs(%arg2 : tensor<1024x640xf32>) -> tensor<1024x640xf32>
      NAIL.yield %m : tensor<1024x640xf32>
    }
    return %r : tensor<1024x640xf32>
  }
}
