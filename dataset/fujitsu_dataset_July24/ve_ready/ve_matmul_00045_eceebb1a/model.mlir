module {
  func.func @kernel(%arg0: tensor<384x1536xi8>, %arg1: tensor<1536x640xi8>, %arg2: tensor<384x640xi32>) -> tensor<384x640xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<384x640xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x1536xi8>, tensor<1536x640xi8>) outs(%arg2 : tensor<384x640xi32>) -> tensor<384x640xi32>
      NAIL.yield %m : tensor<384x640xi32>
    }
    return %r : tensor<384x640xi32>
  }
}
