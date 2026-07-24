module {
  func.func @kernel(%arg0: tensor<2x256x1088xf16>, %arg1: tensor<2x1088x576xf16>, %arg2: tensor<2x256x576xf16>) -> tensor<2x256x576xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2x256x576xf16> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<2x256x1088xf16>, tensor<2x1088x576xf16>) outs(%arg2 : tensor<2x256x576xf16>) -> tensor<2x256x576xf16>
      NAIL.yield %z : tensor<2x256x576xf16>
    }
    return %r : tensor<2x256x576xf16>
  }
}
