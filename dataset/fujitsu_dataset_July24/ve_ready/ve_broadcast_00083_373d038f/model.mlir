module {
  func.func @kernel(%arg0: tensor<72xf16>, %arg1: tensor<4x72xf16>) -> tensor<4x72xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<4x72xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<72xf16>) outs(%arg1 : tensor<4x72xf16>) dimensions = [0]
      NAIL.yield %z : tensor<4x72xf16>
    }
    return %r : tensor<4x72xf16>
  }
}
