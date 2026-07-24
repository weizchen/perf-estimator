module {
  func.func @kernel(%arg0: tensor<49x339xi16>, %arg1: tensor<339x49xi16>) -> tensor<339x49xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<339x49xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<49x339xi16>) outs(%arg1 : tensor<339x49xi16>) permutation = [1, 0]
      NAIL.yield %z : tensor<339x49xi16>
    }
    return %r : tensor<339x49xi16>
  }
}
