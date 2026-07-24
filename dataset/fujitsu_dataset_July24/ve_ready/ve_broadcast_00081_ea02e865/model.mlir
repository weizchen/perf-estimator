module {
  func.func @kernel(%arg0: tensor<30x43xi8>, %arg1: tensor<30x43x263xi8>) -> tensor<30x43x263xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<30x43x263xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<30x43xi8>) outs(%arg1 : tensor<30x43x263xi8>) dimensions = [2]
      NAIL.yield %z : tensor<30x43x263xi8>
    }
    return %r : tensor<30x43x263xi8>
  }
}
