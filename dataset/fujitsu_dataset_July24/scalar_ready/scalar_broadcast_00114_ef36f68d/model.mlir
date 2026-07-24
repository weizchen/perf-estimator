module {
  func.func @kernel(%arg0: tensor<5xi8>, %arg1: tensor<5x14xi8>) -> tensor<5x14xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<5x14xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<5xi8>) outs(%arg1 : tensor<5x14xi8>) dimensions = [1]
      NAIL.yield %z : tensor<5x14xi8>
    }
    return %r : tensor<5x14xi8>
  }
}
