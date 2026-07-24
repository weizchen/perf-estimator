module {
  func.func @kernel(%arg0: tensor<512x640xi8>, %arg1: tensor<640x128xi8>, %arg2: tensor<512x128xi32>) -> tensor<512x128xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<512x128xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x640xi8>, tensor<640x128xi8>) outs(%arg2 : tensor<512x128xi32>) -> tensor<512x128xi32>
      NAIL.yield %m : tensor<512x128xi32>
    }
    return %r : tensor<512x128xi32>
  }
}
