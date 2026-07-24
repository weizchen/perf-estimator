module {
  func.func @kernel(%arg0: tensor<512xf16>, %arg1: tensor<512x704xf16>, %arg2: tensor<704xf32>) -> tensor<704xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<704xf32> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<512xf16>, tensor<512x704xf16>) outs(%arg2 : tensor<704xf32>) -> tensor<704xf32>
      NAIL.yield %z : tensor<704xf32>
    }
    return %r : tensor<704xf32>
  }
}
