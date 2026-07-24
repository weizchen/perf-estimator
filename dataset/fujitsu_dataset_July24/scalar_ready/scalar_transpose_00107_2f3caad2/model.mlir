module {
  func.func @kernel(%arg0: tensor<35x4x10xi8>, %arg1: tensor<10x4x35xi8>) -> tensor<10x4x35xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<10x4x35xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<35x4x10xi8>) outs(%arg1 : tensor<10x4x35xi8>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<10x4x35xi8>
    }
    return %r : tensor<10x4x35xi8>
  }
}
