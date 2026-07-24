module {
  func.func @kernel(%arg0: tensor<31x303xi8>, %arg1: tensor<447x31x303xi8>) -> tensor<447x31x303xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<447x31x303xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<31x303xi8>) outs(%arg1 : tensor<447x31x303xi8>) dimensions = [0]
      NAIL.yield %z : tensor<447x31x303xi8>
    }
    return %r : tensor<447x31x303xi8>
  }
}
