module {
  func.func @kernel(%arg0: tensor<29x30xi8>, %arg1: tensor<29x30xi8>) -> tensor<29x30xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<29x30xi8> {
    %z = linalg.copy ins(%arg0 : tensor<29x30xi8>) outs(%arg1 : tensor<29x30xi8>) -> tensor<29x30xi8>
      NAIL.yield %z : tensor<29x30xi8>
    }
    return %r : tensor<29x30xi8>
  }
}
