module {
  func.func @kernel(%arg0: tensor<59x16xi8>, %arg1: tensor<59x16x347xi8>) -> tensor<59x16x347xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<59x16x347xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<59x16xi8>) outs(%arg1 : tensor<59x16x347xi8>) dimensions = [2]
      NAIL.yield %z : tensor<59x16x347xi8>
    }
    return %r : tensor<59x16x347xi8>
  }
}
