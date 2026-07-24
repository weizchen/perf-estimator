module {
  func.func @kernel(%arg0: tensor<3840x3904xf16>, %arg1: tensor<3904x2112xf16>, %arg2: tensor<3840x2112xf32>) -> tensor<3840x2112xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<3840x2112xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3840x3904xf16>, tensor<3904x2112xf16>) outs(%arg2 : tensor<3840x2112xf32>) -> tensor<3840x2112xf32>
      NAIL.yield %m : tensor<3840x2112xf32>
    }
    return %r : tensor<3840x2112xf32>
  }
}
