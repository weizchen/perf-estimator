module {
  func.func @kernel(%arg0: tensor<2496x384xf16>, %arg1: tensor<384x1024xf16>, %arg2: tensor<2496x1024xf16>) -> tensor<2496x1024xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2496x1024xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2496x384xf16>, tensor<384x1024xf16>) outs(%arg2 : tensor<2496x1024xf16>) -> tensor<2496x1024xf16>
      NAIL.yield %m : tensor<2496x1024xf16>
    }
    return %r : tensor<2496x1024xf16>
  }
}
