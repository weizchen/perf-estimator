module {
  func.func @kernel(%arg0: tensor<5xbf16>, %arg1: tensor<5xbf16>) -> tensor<5xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<5xbf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<exp> ins(%arg0 : tensor<5xbf16>) outs(%arg1 : tensor<5xbf16>) -> tensor<5xbf16>
      NAIL.yield %z : tensor<5xbf16>
    }
    return %r : tensor<5xbf16>
  }
}
