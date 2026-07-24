module {
  func.func @kernel(%arg0: tensor<437x22xi1>, %arg1: tensor<437x22xf16>, %arg2: tensor<437x22xf16>, %arg3: tensor<437x22xf16>) -> tensor<437x22xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<437x22xf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<437x22xi1>, tensor<437x22xf16>, tensor<437x22xf16>) outs(%arg3 : tensor<437x22xf16>) -> tensor<437x22xf16>
      NAIL.yield %z : tensor<437x22xf16>
    }
    return %r : tensor<437x22xf16>
  }
}
