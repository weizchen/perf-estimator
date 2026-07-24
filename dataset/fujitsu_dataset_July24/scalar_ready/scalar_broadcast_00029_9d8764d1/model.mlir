module {
  func.func @kernel(%arg0: tensor<146x4xi8>, %arg1: tensor<146x20x4xi8>) -> tensor<146x20x4xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<146x20x4xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<146x4xi8>) outs(%arg1 : tensor<146x20x4xi8>) dimensions = [1]
      NAIL.yield %z : tensor<146x20x4xi8>
    }
    return %r : tensor<146x20x4xi8>
  }
}
