module {
  func.func @kernel(%arg0: tensor<9x36x6x5xi8>, %arg1: tensor<9x6x36x5xi8>) -> tensor<9x6x36x5xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<9x6x36x5xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<9x36x6x5xi8>) outs(%arg1 : tensor<9x6x36x5xi8>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<9x6x36x5xi8>
    }
    return %r : tensor<9x6x36x5xi8>
  }
}
