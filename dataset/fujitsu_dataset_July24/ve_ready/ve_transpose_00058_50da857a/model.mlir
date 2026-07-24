module {
  func.func @kernel(%arg0: tensor<32x22xi8>, %arg1: tensor<22x32xi8>) -> tensor<22x32xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<22x32xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<32x22xi8>) outs(%arg1 : tensor<22x32xi8>) permutation = [1, 0]
      NAIL.yield %z : tensor<22x32xi8>
    }
    return %r : tensor<22x32xi8>
  }
}
