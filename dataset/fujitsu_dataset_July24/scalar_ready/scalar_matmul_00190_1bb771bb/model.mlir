module {
  func.func @kernel(%arg0: tensor<1536x3904xf16>, %arg1: tensor<3904x192xf16>, %arg2: tensor<1536x192xf32>) -> tensor<1536x192xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1536x192xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1536x3904xf16>, tensor<3904x192xf16>) outs(%arg2 : tensor<1536x192xf32>) -> tensor<1536x192xf32>
      NAIL.yield %m : tensor<1536x192xf32>
    }
    return %r : tensor<1536x192xf32>
  }
}
