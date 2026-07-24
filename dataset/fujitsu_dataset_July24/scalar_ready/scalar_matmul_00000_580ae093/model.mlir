module {
  func.func @kernel(%arg0: tensor<3456x3456xi8>, %arg1: tensor<3456x128xi8>, %arg2: tensor<3456x128xi32>) -> tensor<3456x128xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<3456x128xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3456x3456xi8>, tensor<3456x128xi8>) outs(%arg2 : tensor<3456x128xi32>) -> tensor<3456x128xi32>
      NAIL.yield %m : tensor<3456x128xi32>
    }
    return %r : tensor<3456x128xi32>
  }
}
