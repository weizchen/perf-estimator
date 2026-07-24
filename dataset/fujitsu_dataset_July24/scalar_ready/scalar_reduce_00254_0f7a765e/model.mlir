module {
  func.func @kernel(%arg0: tensor<314x82x16xi16>, %arg1: tensor<314x16xi16>) -> tensor<314x16xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<314x16xi16> {
    %z = linalg.reduce ins(%arg0 : tensor<314x82x16xi16>) outs(%arg1 : tensor<314x16xi16>) dimensions = [1]
      (%in: i16, %acc: i16) {
        %s = arith.maxsi %in, %acc : i16
        linalg.yield %s : i16
      }
      NAIL.yield %z : tensor<314x16xi16>
    }
    return %r : tensor<314x16xi16>
  }
}
