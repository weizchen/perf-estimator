module {
  func.func @kernel(%arg0: tensor<6x78x87xi8>, %arg1: tensor<6x87x78xi8>) -> tensor<6x87x78xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<6x87x78xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<6x78x87xi8>) outs(%arg1 : tensor<6x87x78xi8>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<6x87x78xi8>
    }
    return %r : tensor<6x87x78xi8>
  }
}
