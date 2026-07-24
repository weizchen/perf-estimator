module {
  func.func @kernel(%arg0: tensor<1152x128xi8>, %arg1: tensor<128xi8>, %arg2: tensor<1152xi32>) -> tensor<1152xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1152xi32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<1152x128xi8>, tensor<128xi8>) outs(%arg2 : tensor<1152xi32>) -> tensor<1152xi32>
      NAIL.yield %z : tensor<1152xi32>
    }
    return %r : tensor<1152xi32>
  }
}
