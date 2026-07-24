module {
  func.func @kernel(%arg0: tensor<16x12x20x47xi8>, %arg1: tensor<16x12x47x20xi8>) -> tensor<16x12x47x20xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<16x12x47x20xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<16x12x20x47xi8>) outs(%arg1 : tensor<16x12x47x20xi8>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<16x12x47x20xi8>
    }
    return %r : tensor<16x12x47x20xi8>
  }
}
