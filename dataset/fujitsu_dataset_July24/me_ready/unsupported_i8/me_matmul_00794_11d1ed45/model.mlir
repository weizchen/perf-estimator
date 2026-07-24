module {
  func.func @kernel(%arg0: tensor<1280x1536xi8>, %arg1: tensor<1536x2688xi8>, %arg2: tensor<1280x2688xi32>) -> tensor<1280x2688xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1280x2688xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1280x1536xi8>, tensor<1536x2688xi8>) outs(%arg2 : tensor<1280x2688xi32>) -> tensor<1280x2688xi32>
      NAIL.yield %m : tensor<1280x2688xi32>
    }
    return %r : tensor<1280x2688xi32>
  }
}
