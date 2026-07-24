module {
  func.func @kernel(%arg0: tensor<193xf16>, %arg1: tensor<193xf16>) -> tensor<193xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<193xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<tanh> ins(%arg0 : tensor<193xf16>) outs(%arg1 : tensor<193xf16>) -> tensor<193xf16>
      NAIL.yield %z : tensor<193xf16>
    }
    return %r : tensor<193xf16>
  }
}
