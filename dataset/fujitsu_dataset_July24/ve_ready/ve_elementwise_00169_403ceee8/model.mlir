module {
  func.func @kernel(%arg0: tensor<4x11xf16>, %arg1: tensor<4x11xf16>) -> tensor<4x11xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<4x11xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<tanh> ins(%arg0 : tensor<4x11xf16>) outs(%arg1 : tensor<4x11xf16>) -> tensor<4x11xf16>
      NAIL.yield %z : tensor<4x11xf16>
    }
    return %r : tensor<4x11xf16>
  }
}
