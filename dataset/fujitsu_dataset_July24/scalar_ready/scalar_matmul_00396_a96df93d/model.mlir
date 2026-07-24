module {
  func.func @kernel(%arg0: tensor<3584x704xf32>, %arg1: tensor<704x64xf32>, %arg2: tensor<3584x64xf32>) -> tensor<3584x64xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<3584x64xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3584x704xf32>, tensor<704x64xf32>) outs(%arg2 : tensor<3584x64xf32>) -> tensor<3584x64xf32>
      NAIL.yield %m : tensor<3584x64xf32>
    }
    return %r : tensor<3584x64xf32>
  }
}
