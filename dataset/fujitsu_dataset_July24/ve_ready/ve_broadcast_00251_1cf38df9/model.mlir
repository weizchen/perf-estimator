module {
  func.func @kernel(%arg0: tensor<6xi8>, %arg1: tensor<173x6xi8>) -> tensor<173x6xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<173x6xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<6xi8>) outs(%arg1 : tensor<173x6xi8>) dimensions = [0]
      NAIL.yield %z : tensor<173x6xi8>
    }
    return %r : tensor<173x6xi8>
  }
}
