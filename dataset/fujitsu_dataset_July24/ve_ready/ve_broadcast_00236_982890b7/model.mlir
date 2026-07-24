module {
  func.func @kernel(%arg0: tensor<33xf16>, %arg1: tensor<33x75xf16>) -> tensor<33x75xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<33x75xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<33xf16>) outs(%arg1 : tensor<33x75xf16>) dimensions = [1]
      NAIL.yield %z : tensor<33x75xf16>
    }
    return %r : tensor<33x75xf16>
  }
}
