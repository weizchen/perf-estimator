module {
  func.func @kernel(%arg0: tensor<85x11xf16>, %arg1: tensor<85x146x11xf16>) -> tensor<85x146x11xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<85x146x11xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<85x11xf16>) outs(%arg1 : tensor<85x146x11xf16>) dimensions = [1]
      NAIL.yield %z : tensor<85x146x11xf16>
    }
    return %r : tensor<85x146x11xf16>
  }
}
