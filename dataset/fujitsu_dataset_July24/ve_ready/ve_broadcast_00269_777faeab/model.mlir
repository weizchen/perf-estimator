module {
  func.func @kernel(%arg0: tensor<10xf16>, %arg1: tensor<9x10xf16>) -> tensor<9x10xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<9x10xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<10xf16>) outs(%arg1 : tensor<9x10xf16>) dimensions = [0]
      NAIL.yield %z : tensor<9x10xf16>
    }
    return %r : tensor<9x10xf16>
  }
}
