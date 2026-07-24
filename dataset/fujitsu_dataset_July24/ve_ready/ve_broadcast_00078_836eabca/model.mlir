module {
  func.func @kernel(%arg0: tensor<17xi8>, %arg1: tensor<17x63xi8>) -> tensor<17x63xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<17x63xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<17xi8>) outs(%arg1 : tensor<17x63xi8>) dimensions = [1]
      NAIL.yield %z : tensor<17x63xi8>
    }
    return %r : tensor<17x63xi8>
  }
}
