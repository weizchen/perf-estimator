module {
  func.func @kernel(%arg0: tensor<320x1600xf16>, %arg1: tensor<1600x832xf16>, %arg2: tensor<320x832xf32>) -> tensor<320x832xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<320x832xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<320x1600xf16>, tensor<1600x832xf16>) outs(%arg2 : tensor<320x832xf32>) -> tensor<320x832xf32>
      NAIL.yield %m : tensor<320x832xf32>
    }
    return %r : tensor<320x832xf32>
  }
}
