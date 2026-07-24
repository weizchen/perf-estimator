module {
  func.func @kernel(%arg0: tensor<8x302xi8>, %arg1: tensor<302x8xi8>) -> tensor<302x8xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<302x8xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<8x302xi8>) outs(%arg1 : tensor<302x8xi8>) permutation = [1, 0]
      NAIL.yield %z : tensor<302x8xi8>
    }
    return %r : tensor<302x8xi8>
  }
}
