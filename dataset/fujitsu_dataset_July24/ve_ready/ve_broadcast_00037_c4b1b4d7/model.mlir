module {
  func.func @kernel(%arg0: tensor<8xi8>, %arg1: tensor<118x8xi8>) -> tensor<118x8xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<118x8xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<8xi8>) outs(%arg1 : tensor<118x8xi8>) dimensions = [0]
      NAIL.yield %z : tensor<118x8xi8>
    }
    return %r : tensor<118x8xi8>
  }
}
