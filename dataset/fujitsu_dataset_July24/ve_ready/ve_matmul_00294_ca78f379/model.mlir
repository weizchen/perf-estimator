module {
  func.func @kernel(%arg0: tensor<896x4032xf16>, %arg1: tensor<4032x1344xf16>, %arg2: tensor<896x1344xf16>) -> tensor<896x1344xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<896x1344xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<896x4032xf16>, tensor<4032x1344xf16>) outs(%arg2 : tensor<896x1344xf16>) -> tensor<896x1344xf16>
      NAIL.yield %m : tensor<896x1344xf16>
    }
    return %r : tensor<896x1344xf16>
  }
}
