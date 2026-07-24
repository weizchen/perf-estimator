module {
  func.func @kernel(%arg0: tensor<640x256xi8>, %arg1: tensor<256x1280xi8>, %arg2: tensor<640x1280xi32>) -> tensor<640x1280xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<640x1280xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<640x256xi8>, tensor<256x1280xi8>) outs(%arg2 : tensor<640x1280xi32>) -> tensor<640x1280xi32>
      NAIL.yield %m : tensor<640x1280xi32>
    }
    return %r : tensor<640x1280xi32>
  }
}
