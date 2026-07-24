module {
  func.func @kernel(%arg0: tensor<896x256xi8>, %arg1: tensor<256xi8>, %arg2: tensor<896xi32>) -> tensor<896xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<896xi32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<896x256xi8>, tensor<256xi8>) outs(%arg2 : tensor<896xi32>) -> tensor<896xi32>
      NAIL.yield %z : tensor<896xi32>
    }
    return %r : tensor<896xi32>
  }
}
