module {
  func.func @kernel(%arg0: tensor<32x27xi8>, %arg1: tensor<8x32x27xi8>) -> tensor<8x32x27xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<8x32x27xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<32x27xi8>) outs(%arg1 : tensor<8x32x27xi8>) dimensions = [0]
      NAIL.yield %z : tensor<8x32x27xi8>
    }
    return %r : tensor<8x32x27xi8>
  }
}
