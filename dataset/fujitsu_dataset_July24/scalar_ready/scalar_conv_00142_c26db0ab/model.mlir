module {
  func.func @kernel(%arg0: tensor<1x12x12x1xi8>, %arg1: tensor<5x5x1x26xi8>, %arg2: tensor<1x4x4x26xi32>) -> tensor<1x4x4x26xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x4x4x26xi32> {
      %c = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>, strides = dense<2> : tensor<2xi64>} ins(%arg0, %arg1 : tensor<1x12x12x1xi8>, tensor<5x5x1x26xi8>) outs(%arg2 : tensor<1x4x4x26xi32>) -> tensor<1x4x4x26xi32>
      NAIL.yield %c : tensor<1x4x4x26xi32>
    }
    return %r : tensor<1x4x4x26xi32>
  }
}
