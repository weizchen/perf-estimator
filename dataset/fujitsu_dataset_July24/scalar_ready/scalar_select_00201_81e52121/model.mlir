module {
  func.func @kernel(%arg0: tensor<17xi1>, %arg1: tensor<17xf16>, %arg2: tensor<17xf16>, %arg3: tensor<17xf16>) -> tensor<17xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<17xf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<17xi1>, tensor<17xf16>, tensor<17xf16>) outs(%arg3 : tensor<17xf16>) -> tensor<17xf16>
      NAIL.yield %z : tensor<17xf16>
    }
    return %r : tensor<17xf16>
  }
}
