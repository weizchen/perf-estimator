module {
  func.func @kernel(%arg0: tensor<421x4x20xi16>, %arg1: tensor<421x4xi16>) -> tensor<421x4xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<421x4xi16> {
    %z = linalg.reduce ins(%arg0 : tensor<421x4x20xi16>) outs(%arg1 : tensor<421x4xi16>) dimensions = [2]
      (%in: i16, %acc: i16) {
        %s = arith.muli %in, %acc : i16
        linalg.yield %s : i16
      }
      NAIL.yield %z : tensor<421x4xi16>
    }
    return %r : tensor<421x4xi16>
  }
}
