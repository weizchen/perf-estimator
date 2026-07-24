module {
  func.func @kernel(%arg0: tensor<13x4xi8>, %arg1: tensor<13x4x49xi8>) -> tensor<13x4x49xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<13x4x49xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<13x4xi8>) outs(%arg1 : tensor<13x4x49xi8>) dimensions = [2]
      NAIL.yield %z : tensor<13x4x49xi8>
    }
    return %r : tensor<13x4x49xi8>
  }
}
