module {
  func.func @kernel(%arg0: tensor<246x36x9xf16>, %arg1: tensor<246x36x9xf16>) -> tensor<246x36x9xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<246x36x9xf16> {
    %z = linalg.copy ins(%arg0 : tensor<246x36x9xf16>) outs(%arg1 : tensor<246x36x9xf16>) -> tensor<246x36x9xf16>
      NAIL.yield %z : tensor<246x36x9xf16>
    }
    return %r : tensor<246x36x9xf16>
  }
}
