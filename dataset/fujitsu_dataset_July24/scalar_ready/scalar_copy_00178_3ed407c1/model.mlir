module {
  func.func @kernel(%arg0: tensor<390x4xf16>, %arg1: tensor<390x4xf16>) -> tensor<390x4xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<390x4xf16> {
    %z = linalg.copy ins(%arg0 : tensor<390x4xf16>) outs(%arg1 : tensor<390x4xf16>) -> tensor<390x4xf16>
      NAIL.yield %z : tensor<390x4xf16>
    }
    return %r : tensor<390x4xf16>
  }
}
