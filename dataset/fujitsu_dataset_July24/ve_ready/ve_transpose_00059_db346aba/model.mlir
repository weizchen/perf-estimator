module {
  func.func @kernel(%arg0: tensor<25x6x13x7xi8>, %arg1: tensor<25x7x13x6xi8>) -> tensor<25x7x13x6xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<25x7x13x6xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<25x6x13x7xi8>) outs(%arg1 : tensor<25x7x13x6xi8>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<25x7x13x6xi8>
    }
    return %r : tensor<25x7x13x6xi8>
  }
}
