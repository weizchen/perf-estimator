module {
  func.func @kernel(%arg0: tensor<29x346xi16>, %arg1: tensor<29xi16>) -> tensor<29xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<29xi16> {
    %z = linalg.reduce ins(%arg0 : tensor<29x346xi16>) outs(%arg1 : tensor<29xi16>) dimensions = [1]
      (%in: i16, %acc: i16) {
        %s = arith.addi %in, %acc : i16
        linalg.yield %s : i16
      }
      NAIL.yield %z : tensor<29xi16>
    }
    return %r : tensor<29xi16>
  }
}
