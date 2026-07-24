module {
  func.func @kernel(%arg0: tensor<1024x3456xi8>, %arg1: tensor<3456x2816xi8>, %arg2: tensor<1024x2816xi32>) -> tensor<1024x2816xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1024x2816xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1024x3456xi8>, tensor<3456x2816xi8>) outs(%arg2 : tensor<1024x2816xi32>) -> tensor<1024x2816xi32>
      NAIL.yield %m : tensor<1024x2816xi32>
    }
    return %r : tensor<1024x2816xi32>
  }
}
