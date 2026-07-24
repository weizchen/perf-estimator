module {
  func.func @kernel(%arg0: tensor<6x252xi8>, %arg1: tensor<252x6xi8>) -> tensor<252x6xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<252x6xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<6x252xi8>) outs(%arg1 : tensor<252x6xi8>) permutation = [1, 0]
      NAIL.yield %z : tensor<252x6xi8>
    }
    return %r : tensor<252x6xi8>
  }
}
