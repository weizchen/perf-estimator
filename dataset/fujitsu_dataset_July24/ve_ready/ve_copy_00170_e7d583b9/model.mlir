module {
  func.func @kernel(%arg0: tensor<41x18x244xf16>, %arg1: tensor<41x18x244xf16>) -> tensor<41x18x244xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<41x18x244xf16> {
    %z = linalg.copy ins(%arg0 : tensor<41x18x244xf16>) outs(%arg1 : tensor<41x18x244xf16>) -> tensor<41x18x244xf16>
      NAIL.yield %z : tensor<41x18x244xf16>
    }
    return %r : tensor<41x18x244xf16>
  }
}
