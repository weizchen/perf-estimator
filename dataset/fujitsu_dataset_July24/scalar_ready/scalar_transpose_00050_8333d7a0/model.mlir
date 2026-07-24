module {
  func.func @kernel(%arg0: tensor<16x40xi8>, %arg1: tensor<40x16xi8>) -> tensor<40x16xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<40x16xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<16x40xi8>) outs(%arg1 : tensor<40x16xi8>) permutation = [1, 0]
      NAIL.yield %z : tensor<40x16xi8>
    }
    return %r : tensor<40x16xi8>
  }
}
