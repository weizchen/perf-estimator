module {
  func.func @kernel(%arg0: tensor<10x4x33xi8>, %arg1: tensor<33x4x10xi8>) -> tensor<33x4x10xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<33x4x10xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<10x4x33xi8>) outs(%arg1 : tensor<33x4x10xi8>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<33x4x10xi8>
    }
    return %r : tensor<33x4x10xi8>
  }
}
