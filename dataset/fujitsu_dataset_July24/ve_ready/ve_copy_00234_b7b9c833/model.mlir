module {
  func.func @kernel(%arg0: tensor<91x118xi8>, %arg1: tensor<91x118xi8>) -> tensor<91x118xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<91x118xi8> {
    %z = linalg.copy ins(%arg0 : tensor<91x118xi8>) outs(%arg1 : tensor<91x118xi8>) -> tensor<91x118xi8>
      NAIL.yield %z : tensor<91x118xi8>
    }
    return %r : tensor<91x118xi8>
  }
}
