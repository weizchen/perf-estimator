module {
  func.func @kernel(%arg0: tensor<2496x448xf32>, %arg1: tensor<448x3456xf32>, %arg2: tensor<2496x3456xf32>) -> tensor<2496x3456xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2496x3456xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2496x448xf32>, tensor<448x3456xf32>) outs(%arg2 : tensor<2496x3456xf32>) -> tensor<2496x3456xf32>
      NAIL.yield %m : tensor<2496x3456xf32>
    }
    return %r : tensor<2496x3456xf32>
  }
}
