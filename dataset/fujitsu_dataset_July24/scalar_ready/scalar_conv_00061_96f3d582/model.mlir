module {
  func.func @kernel(%arg0: tensor<1x17x17x9xf32>, %arg1: tensor<3x3x9x1xf32>, %arg2: tensor<1x8x8x1xf32>) -> tensor<1x8x8x1xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x8x8x1xf32> {
      %c = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>, strides = dense<2> : tensor<2xi64>} ins(%arg0, %arg1 : tensor<1x17x17x9xf32>, tensor<3x3x9x1xf32>) outs(%arg2 : tensor<1x8x8x1xf32>) -> tensor<1x8x8x1xf32>
      NAIL.yield %c : tensor<1x8x8x1xf32>
    }
    return %r : tensor<1x8x8x1xf32>
  }
}
