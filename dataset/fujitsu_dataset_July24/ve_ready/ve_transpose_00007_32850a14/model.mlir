module {
  func.func @kernel(%arg0: tensor<45x4x96xi16>, %arg1: tensor<45x96x4xi16>) -> tensor<45x96x4xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<45x96x4xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<45x4x96xi16>) outs(%arg1 : tensor<45x96x4xi16>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<45x96x4xi16>
    }
    return %r : tensor<45x96x4xi16>
  }
}
