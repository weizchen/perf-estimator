module {
  func.func @kernel(%arg0: tensor<1x12x12x25xf32>, %arg1: tensor<1x1x25x39xf32>, %arg2: tensor<1x12x12x39xf32>) -> tensor<1x12x12x39xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x12x12x39xf32> {
      %c = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} ins(%arg0, %arg1 : tensor<1x12x12x25xf32>, tensor<1x1x25x39xf32>) outs(%arg2 : tensor<1x12x12x39xf32>) -> tensor<1x12x12x39xf32>
      NAIL.yield %c : tensor<1x12x12x39xf32>
    }
    return %r : tensor<1x12x12x39xf32>
  }
}
