module {
  func.func @kernel(%arg0: tensor<60x394x379xi16>, %arg1: tensor<394x379xi16>) -> tensor<394x379xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<394x379xi16> {
    %z = linalg.reduce ins(%arg0 : tensor<60x394x379xi16>) outs(%arg1 : tensor<394x379xi16>) dimensions = [0]
      (%in: i16, %acc: i16) {
        %s = arith.muli %in, %acc : i16
        linalg.yield %s : i16
      }
      NAIL.yield %z : tensor<394x379xi16>
    }
    return %r : tensor<394x379xi16>
  }
}
