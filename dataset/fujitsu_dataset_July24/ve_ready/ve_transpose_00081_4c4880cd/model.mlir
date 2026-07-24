module {
  func.func @kernel(%arg0: tensor<61x6x94xi8>, %arg1: tensor<6x61x94xi8>) -> tensor<6x61x94xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<6x61x94xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<61x6x94xi8>) outs(%arg1 : tensor<6x61x94xi8>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<6x61x94xi8>
    }
    return %r : tensor<6x61x94xi8>
  }
}
