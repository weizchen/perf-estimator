module {
  func.func @kernel(%arg0: tensor<9x5xi8>, %arg1: tensor<9x50x5xi8>) -> tensor<9x50x5xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<9x50x5xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<9x5xi8>) outs(%arg1 : tensor<9x50x5xi8>) dimensions = [1]
      NAIL.yield %z : tensor<9x50x5xi8>
    }
    return %r : tensor<9x50x5xi8>
  }
}
