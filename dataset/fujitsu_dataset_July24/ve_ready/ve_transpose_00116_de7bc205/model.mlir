module {
  func.func @kernel(%arg0: tensor<18x28x6xi8>, %arg1: tensor<18x6x28xi8>) -> tensor<18x6x28xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<18x6x28xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<18x28x6xi8>) outs(%arg1 : tensor<18x6x28xi8>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<18x6x28xi8>
    }
    return %r : tensor<18x6x28xi8>
  }
}
