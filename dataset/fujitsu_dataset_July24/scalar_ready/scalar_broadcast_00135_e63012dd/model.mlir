module {
  func.func @kernel(%arg0: tensor<4x21xf16>, %arg1: tensor<4x5x21xf16>) -> tensor<4x5x21xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x5x21xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<4x21xf16>) outs(%arg1 : tensor<4x5x21xf16>) dimensions = [1]
      NAIL.yield %z : tensor<4x5x21xf16>
    }
    return %r : tensor<4x5x21xf16>
  }
}
