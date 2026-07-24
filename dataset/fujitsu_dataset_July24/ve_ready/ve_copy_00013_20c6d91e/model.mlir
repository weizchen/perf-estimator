module {
  func.func @kernel(%arg0: tensor<4xi16>, %arg1: tensor<4xi16>) -> tensor<4xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<4xi16> {
    %z = linalg.copy ins(%arg0 : tensor<4xi16>) outs(%arg1 : tensor<4xi16>) -> tensor<4xi16>
      NAIL.yield %z : tensor<4xi16>
    }
    return %r : tensor<4xi16>
  }
}
