module {
  func.func @kernel(%arg0: tensor<4032x640xbf16>, %arg1: tensor<640x576xbf16>, %arg2: tensor<4032x576xf32>) -> tensor<4032x576xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<4032x576xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<4032x640xbf16>, tensor<640x576xbf16>) outs(%arg2 : tensor<4032x576xf32>) -> tensor<4032x576xf32>
      NAIL.yield %m : tensor<4032x576xf32>
    }
    return %r : tensor<4032x576xf32>
  }
}
