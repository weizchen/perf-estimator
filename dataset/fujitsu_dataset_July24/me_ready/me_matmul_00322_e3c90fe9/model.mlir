module {
  func.func @kernel(%arg0: tensor<1920x640xf16>, %arg1: tensor<640x3328xf16>, %arg2: tensor<1920x3328xf32>) -> tensor<1920x3328xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1920x3328xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1920x640xf16>, tensor<640x3328xf16>) outs(%arg2 : tensor<1920x3328xf32>) -> tensor<1920x3328xf32>
      NAIL.yield %m : tensor<1920x3328xf32>
    }
    return %r : tensor<1920x3328xf32>
  }
}
