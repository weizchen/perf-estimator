module {
  func.func @kernel(%arg0: tensor<1x31x31x1xf32>, %arg1: tensor<5x5x1x3xf32>, %arg2: tensor<1x14x14x3xf32>) -> tensor<1x14x14x3xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x14x14x3xf32> {
      %c = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>, strides = dense<2> : tensor<2xi64>} ins(%arg0, %arg1 : tensor<1x31x31x1xf32>, tensor<5x5x1x3xf32>) outs(%arg2 : tensor<1x14x14x3xf32>) -> tensor<1x14x14x3xf32>
      NAIL.yield %c : tensor<1x14x14x3xf32>
    }
    return %r : tensor<1x14x14x3xf32>
  }
}
