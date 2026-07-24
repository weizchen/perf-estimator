module {
  func.func @kernel(%arg0: tensor<1x46x46x41xf16>, %arg1: tensor<5x5x41x11xf16>, %arg2: tensor<1x42x42x11xf32>) -> tensor<1x42x42x11xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x42x42x11xf32> {
      %c = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} ins(%arg0, %arg1 : tensor<1x46x46x41xf16>, tensor<5x5x41x11xf16>) outs(%arg2 : tensor<1x42x42x11xf32>) -> tensor<1x42x42x11xf32>
      NAIL.yield %c : tensor<1x42x42x11xf32>
    }
    return %r : tensor<1x42x42x11xf32>
  }
}
