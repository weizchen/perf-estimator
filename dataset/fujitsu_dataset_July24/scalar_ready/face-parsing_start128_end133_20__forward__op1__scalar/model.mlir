module {
  func.func @kernel(%arg0: tensor<1x64x130x130xf32>, %arg1: tensor<128x64x3x3xf32>, %arg2: tensor<1x128x64x64xf32>) -> tensor<1x128x64x64xf32> {
    %0 = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0,proc : 0> -> tensor<1x128x64x64xf32> {
      %1 = linalg.conv_2d_nchw_fchw {dilations = dense<1> : vector<2xi64>, strides = dense<2> : vector<2xi64>} ins(%arg0, %arg1 : tensor<1x64x130x130xf32>, tensor<128x64x3x3xf32>) outs(%arg2 : tensor<1x128x64x64xf32>) -> tensor<1x128x64x64xf32>
      NAIL.yield %1 : tensor<1x128x64x64xf32>
    }
    return %0 : tensor<1x128x64x64xf32>
  }
}
