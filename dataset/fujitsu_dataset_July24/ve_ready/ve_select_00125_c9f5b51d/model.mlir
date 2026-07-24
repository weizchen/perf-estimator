module {
  func.func @kernel(%arg0: tensor<34x63xi1>, %arg1: tensor<34x63xbf16>, %arg2: tensor<34x63xbf16>, %arg3: tensor<34x63xbf16>) -> tensor<34x63xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<34x63xbf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<34x63xi1>, tensor<34x63xbf16>, tensor<34x63xbf16>) outs(%arg3 : tensor<34x63xbf16>) -> tensor<34x63xbf16>
      NAIL.yield %z : tensor<34x63xbf16>
    }
    return %r : tensor<34x63xbf16>
  }
}
