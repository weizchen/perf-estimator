module {
  func.func @kernel(%arg0: tensor<110x14x69xf16>, %arg1: tensor<110x14x69xf16>) -> tensor<110x14x69xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<110x14x69xf16> {
    %z = linalg.copy ins(%arg0 : tensor<110x14x69xf16>) outs(%arg1 : tensor<110x14x69xf16>) -> tensor<110x14x69xf16>
      NAIL.yield %z : tensor<110x14x69xf16>
    }
    return %r : tensor<110x14x69xf16>
  }
}
