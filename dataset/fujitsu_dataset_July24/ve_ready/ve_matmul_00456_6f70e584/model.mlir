module {
  func.func @kernel(%arg0: tensor<896x1024xf32>, %arg1: tensor<1024x2944xf32>, %arg2: tensor<896x2944xf32>) -> tensor<896x2944xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<896x2944xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<896x1024xf32>, tensor<1024x2944xf32>) outs(%arg2 : tensor<896x2944xf32>) -> tensor<896x2944xf32>
      NAIL.yield %m : tensor<896x2944xf32>
    }
    return %r : tensor<896x2944xf32>
  }
}
