module {
  func.func @kernel(%arg0: tensor<7x188xi8>, %arg1: tensor<7x11x188xi8>) -> tensor<7x11x188xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<7x11x188xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<7x188xi8>) outs(%arg1 : tensor<7x11x188xi8>) dimensions = [1]
      NAIL.yield %z : tensor<7x11x188xi8>
    }
    return %r : tensor<7x11x188xi8>
  }
}
