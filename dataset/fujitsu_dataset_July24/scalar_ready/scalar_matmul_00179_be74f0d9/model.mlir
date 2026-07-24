module {
  func.func @kernel(%arg0: tensor<576x1088xf16>, %arg1: tensor<1088x2432xf16>, %arg2: tensor<576x2432xf32>) -> tensor<576x2432xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<576x2432xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<576x1088xf16>, tensor<1088x2432xf16>) outs(%arg2 : tensor<576x2432xf32>) -> tensor<576x2432xf32>
      NAIL.yield %m : tensor<576x2432xf32>
    }
    return %r : tensor<576x2432xf32>
  }
}
