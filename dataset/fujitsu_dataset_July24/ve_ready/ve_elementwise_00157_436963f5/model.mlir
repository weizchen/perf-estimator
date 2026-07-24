module {
  func.func @kernel(%arg0: tensor<53x14xf16>, %arg1: tensor<53x14xf16>) -> tensor<53x14xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<53x14xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<negf> ins(%arg0 : tensor<53x14xf16>) outs(%arg1 : tensor<53x14xf16>) -> tensor<53x14xf16>
      NAIL.yield %z : tensor<53x14xf16>
    }
    return %r : tensor<53x14xf16>
  }
}
