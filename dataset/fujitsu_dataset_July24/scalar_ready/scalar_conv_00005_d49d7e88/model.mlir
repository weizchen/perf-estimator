module {
  func.func @kernel(%arg0: tensor<1x48x48x2xf32>, %arg1: tensor<7x7x2x28xf32>, %arg2: tensor<1x21x21x28xf32>) -> tensor<1x21x21x28xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x21x21x28xf32> {
      %c = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>, strides = dense<2> : tensor<2xi64>} ins(%arg0, %arg1 : tensor<1x48x48x2xf32>, tensor<7x7x2x28xf32>) outs(%arg2 : tensor<1x21x21x28xf32>) -> tensor<1x21x21x28xf32>
      NAIL.yield %c : tensor<1x21x21x28xf32>
    }
    return %r : tensor<1x21x21x28xf32>
  }
}
