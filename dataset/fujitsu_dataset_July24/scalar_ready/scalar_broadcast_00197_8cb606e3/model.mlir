module {
  func.func @kernel(%arg0: tensor<141x64xf16>, %arg1: tensor<4x141x64xf16>) -> tensor<4x141x64xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x141x64xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<141x64xf16>) outs(%arg1 : tensor<4x141x64xf16>) dimensions = [0]
      NAIL.yield %z : tensor<4x141x64xf16>
    }
    return %r : tensor<4x141x64xf16>
  }
}
