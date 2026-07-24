module {
  func.func @kernel(%arg0: tensor<10x6xi16>, %arg1: tensor<10x6xi16>) -> tensor<10x6xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<10x6xi16> {
    %z = linalg.copy ins(%arg0 : tensor<10x6xi16>) outs(%arg1 : tensor<10x6xi16>) -> tensor<10x6xi16>
      NAIL.yield %z : tensor<10x6xi16>
    }
    return %r : tensor<10x6xi16>
  }
}
