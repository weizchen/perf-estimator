module {
  func.func @main(%arg0: tensor<8x16xf32>, %arg1: tensor<8x16xf32>) -> tensor<8x16xf32> {
    %0 = linalg.softmax dimension(1) ins(%arg0 : tensor<8x16xf32>) outs(%arg1 : tensor<8x16xf32>) -> tensor<8x16xf32>
    return %0 : tensor<8x16xf32>
  }
}

