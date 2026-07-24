module {
  func.func @kernel(%arg0: tensor<93xf16>, %arg1: tensor<119x93xf16>) -> tensor<119x93xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<119x93xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<93xf16>) outs(%arg1 : tensor<119x93xf16>) dimensions = [0]
      NAIL.yield %z : tensor<119x93xf16>
    }
    return %r : tensor<119x93xf16>
  }
}
