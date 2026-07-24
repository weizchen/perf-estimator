module {
  func.func @kernel(%arg0: tensor<1x41x41x16xf16>, %arg1: tensor<3x3x16x56xf16>, %arg2: tensor<1x39x39x56xf32>) -> tensor<1x39x39x56xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x39x39x56xf32> {
      %c = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} ins(%arg0, %arg1 : tensor<1x41x41x16xf16>, tensor<3x3x16x56xf16>) outs(%arg2 : tensor<1x39x39x56xf32>) -> tensor<1x39x39x56xf32>
      NAIL.yield %c : tensor<1x39x39x56xf32>
    }
    return %r : tensor<1x39x39x56xf32>
  }
}
