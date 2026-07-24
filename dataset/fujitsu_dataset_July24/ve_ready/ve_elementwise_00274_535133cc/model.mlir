module {
  func.func @kernel(%arg0: tensor<110xf16>, %arg1: tensor<110xf16>) -> tensor<110xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<110xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<exp> ins(%arg0 : tensor<110xf16>) outs(%arg1 : tensor<110xf16>) -> tensor<110xf16>
      NAIL.yield %z : tensor<110xf16>
    }
    return %r : tensor<110xf16>
  }
}
