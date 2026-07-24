module {
  func.func @kernel(%arg0: tensor<392x128xi8>, %arg1: tensor<392x128x15xi8>) -> tensor<392x128x15xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<392x128x15xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<392x128xi8>) outs(%arg1 : tensor<392x128x15xi8>) dimensions = [2]
      NAIL.yield %z : tensor<392x128x15xi8>
    }
    return %r : tensor<392x128x15xi8>
  }
}
