module {
  func.func @kernel(%arg0: tensor<2x1280x704xf16>, %arg1: tensor<2x704x1856xf16>, %arg2: tensor<2x1280x1856xf32>) -> tensor<2x1280x1856xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2x1280x1856xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<2x1280x704xf16>, tensor<2x704x1856xf16>) outs(%arg2 : tensor<2x1280x1856xf32>) -> tensor<2x1280x1856xf32>
      NAIL.yield %z : tensor<2x1280x1856xf32>
    }
    return %r : tensor<2x1280x1856xf32>
  }
}
