module {
  func.func @kernel(%arg0: tensor<320x896xf16>, %arg1: tensor<896xf16>, %arg2: tensor<320xf32>) -> tensor<320xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<320xf32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<320x896xf16>, tensor<896xf16>) outs(%arg2 : tensor<320xf32>) -> tensor<320xf32>
      NAIL.yield %z : tensor<320xf32>
    }
    return %r : tensor<320xf32>
  }
}
