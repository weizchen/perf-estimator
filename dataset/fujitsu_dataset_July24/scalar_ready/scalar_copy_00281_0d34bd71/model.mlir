module {
  func.func @kernel(%arg0: tensor<320x7xi8>, %arg1: tensor<320x7xi8>) -> tensor<320x7xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<320x7xi8> {
    %z = linalg.copy ins(%arg0 : tensor<320x7xi8>) outs(%arg1 : tensor<320x7xi8>) -> tensor<320x7xi8>
      NAIL.yield %z : tensor<320x7xi8>
    }
    return %r : tensor<320x7xi8>
  }
}
