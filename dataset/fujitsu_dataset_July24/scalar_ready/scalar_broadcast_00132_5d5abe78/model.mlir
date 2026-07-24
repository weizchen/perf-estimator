module {
  func.func @kernel(%arg0: tensor<122xf16>, %arg1: tensor<122x47xf16>) -> tensor<122x47xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<122x47xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<122xf16>) outs(%arg1 : tensor<122x47xf16>) dimensions = [1]
      NAIL.yield %z : tensor<122x47xf16>
    }
    return %r : tensor<122x47xf16>
  }
}
