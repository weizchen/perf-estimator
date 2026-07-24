module {
  func.func @kernel(%arg0: tensor<960x960xf16>, %arg1: tensor<960x3200xf16>, %arg2: tensor<960x3200xf32>) -> tensor<960x3200xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<960x3200xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<960x960xf16>, tensor<960x3200xf16>) outs(%arg2 : tensor<960x3200xf32>) -> tensor<960x3200xf32>
      NAIL.yield %m : tensor<960x3200xf32>
    }
    return %r : tensor<960x3200xf32>
  }
}
