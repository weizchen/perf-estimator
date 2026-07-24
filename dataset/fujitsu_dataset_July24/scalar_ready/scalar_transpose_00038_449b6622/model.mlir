module {
  func.func @kernel(%arg0: tensor<480x28xf16>, %arg1: tensor<28x480xf16>) -> tensor<28x480xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<28x480xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<480x28xf16>) outs(%arg1 : tensor<28x480xf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<28x480xf16>
    }
    return %r : tensor<28x480xf16>
  }
}
