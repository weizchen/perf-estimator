module {
  func.func @kernel(%arg0: tensor<1x11x11x12xi8>, %arg1: tensor<3x3x12x12xi8>, %arg2: tensor<1x5x5x12xi32>) -> tensor<1x5x5x12xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x5x5x12xi32> {
      %c = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>, strides = dense<2> : tensor<2xi64>} ins(%arg0, %arg1 : tensor<1x11x11x12xi8>, tensor<3x3x12x12xi8>) outs(%arg2 : tensor<1x5x5x12xi32>) -> tensor<1x5x5x12xi32>
      NAIL.yield %c : tensor<1x5x5x12xi32>
    }
    return %r : tensor<1x5x5x12xi32>
  }
}
