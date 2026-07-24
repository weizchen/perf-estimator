module {
  func.func @kernel(%arg0: tensor<272xi8>, %arg1: tensor<272xi8>) -> tensor<272xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<272xi8> {
    %z = linalg.copy ins(%arg0 : tensor<272xi8>) outs(%arg1 : tensor<272xi8>) -> tensor<272xi8>
      NAIL.yield %z : tensor<272xi8>
    }
    return %r : tensor<272xi8>
  }
}
