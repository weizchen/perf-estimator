module {
  func.func @kernel(%arg0: tensor<20x209xi16>, %arg1: tensor<209x20xi16>) -> tensor<209x20xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<209x20xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<20x209xi16>) outs(%arg1 : tensor<209x20xi16>) permutation = [1, 0]
      NAIL.yield %z : tensor<209x20xi16>
    }
    return %r : tensor<209x20xi16>
  }
}
