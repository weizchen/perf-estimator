module {
  func.func @kernel(%arg0: tensor<256x640xi8>, %arg1: tensor<640xi8>, %arg2: tensor<256xi32>) -> tensor<256xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<256xi32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<256x640xi8>, tensor<640xi8>) outs(%arg2 : tensor<256xi32>) -> tensor<256xi32>
      NAIL.yield %z : tensor<256xi32>
    }
    return %r : tensor<256xi32>
  }
}
