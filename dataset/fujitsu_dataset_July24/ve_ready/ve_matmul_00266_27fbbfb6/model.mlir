module {
  func.func @kernel(%arg0: tensor<1664x1216xf16>, %arg1: tensor<1216x1408xf16>, %arg2: tensor<1664x1408xf16>) -> tensor<1664x1408xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1664x1408xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1664x1216xf16>, tensor<1216x1408xf16>) outs(%arg2 : tensor<1664x1408xf16>) -> tensor<1664x1408xf16>
      NAIL.yield %m : tensor<1664x1408xf16>
    }
    return %r : tensor<1664x1408xf16>
  }
}
