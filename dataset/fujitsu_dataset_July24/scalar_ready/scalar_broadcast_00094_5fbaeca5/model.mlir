module {
  func.func @kernel(%arg0: tensor<23xi8>, %arg1: tensor<23x39xi8>) -> tensor<23x39xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<23x39xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<23xi8>) outs(%arg1 : tensor<23x39xi8>) dimensions = [1]
      NAIL.yield %z : tensor<23x39xi8>
    }
    return %r : tensor<23x39xi8>
  }
}
