module {
  func.func @kernel(%arg0: tensor<37x7xi8>, %arg1: tensor<37x7xi8>, %arg2: tensor<37x7xi8>) -> tensor<37x7xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<37x7xi8> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<max_signed> ins(%arg0, %arg1 : tensor<37x7xi8>, tensor<37x7xi8>) outs(%arg2 : tensor<37x7xi8>) -> tensor<37x7xi8>
      NAIL.yield %z : tensor<37x7xi8>
    }
    return %r : tensor<37x7xi8>
  }
}
