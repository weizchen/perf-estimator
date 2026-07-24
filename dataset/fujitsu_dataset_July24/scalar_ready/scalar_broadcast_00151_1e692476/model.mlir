module {
  func.func @kernel(%arg0: tensor<285x504xi16>, %arg1: tensor<285x504x4xi16>) -> tensor<285x504x4xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<285x504x4xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<285x504xi16>) outs(%arg1 : tensor<285x504x4xi16>) dimensions = [2]
      NAIL.yield %z : tensor<285x504x4xi16>
    }
    return %r : tensor<285x504x4xi16>
  }
}
