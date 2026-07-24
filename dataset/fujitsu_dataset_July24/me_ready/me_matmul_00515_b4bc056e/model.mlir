module {
  func.func @kernel(%arg0: tensor<704x1216xf16>, %arg1: tensor<1216x1984xf16>, %arg2: tensor<704x1984xf32>) -> tensor<704x1984xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<704x1984xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<704x1216xf16>, tensor<1216x1984xf16>) outs(%arg2 : tensor<704x1984xf32>) -> tensor<704x1984xf32>
      NAIL.yield %m : tensor<704x1984xf32>
    }
    return %r : tensor<704x1984xf32>
  }
}
