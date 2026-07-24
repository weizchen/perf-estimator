module {
  func.func @kernel(%arg0: tensor<20x43x14xi16>, %arg1: tensor<20x14xi16>) -> tensor<20x14xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<20x14xi16> {
    %z = linalg.reduce ins(%arg0 : tensor<20x43x14xi16>) outs(%arg1 : tensor<20x14xi16>) dimensions = [1]
      (%in: i16, %acc: i16) {
        %s = arith.maxsi %in, %acc : i16
        linalg.yield %s : i16
      }
      NAIL.yield %z : tensor<20x14xi16>
    }
    return %r : tensor<20x14xi16>
  }
}
