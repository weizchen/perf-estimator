module {
  func.func @kernel(%arg0: tensor<896x1408xf16>, %arg1: tensor<1408x1088xf16>, %arg2: tensor<896x1088xf16>) -> tensor<896x1088xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<896x1088xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<896x1408xf16>, tensor<1408x1088xf16>) outs(%arg2 : tensor<896x1088xf16>) -> tensor<896x1088xf16>
      NAIL.yield %m : tensor<896x1088xf16>
    }
    return %r : tensor<896x1088xf16>
  }
}
