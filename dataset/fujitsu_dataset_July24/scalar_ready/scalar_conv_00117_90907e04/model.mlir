module {
  func.func @kernel(%arg0: tensor<1x50x50x2xf16>, %arg1: tensor<7x7x2x4xf16>, %arg2: tensor<1x44x44x4xf32>) -> tensor<1x44x44x4xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x44x44x4xf32> {
      %c = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} ins(%arg0, %arg1 : tensor<1x50x50x2xf16>, tensor<7x7x2x4xf16>) outs(%arg2 : tensor<1x44x44x4xf32>) -> tensor<1x44x44x4xf32>
      NAIL.yield %c : tensor<1x44x44x4xf32>
    }
    return %r : tensor<1x44x44x4xf32>
  }
}
