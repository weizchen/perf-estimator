module {
  func.func @kernel(%arg0: tensor<6x11xf32>, %arg1: tensor<6x11xf32>, %arg2: tensor<6x11xf32>) -> tensor<6x11xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<6x11xf32> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<max_signed> ins(%arg0, %arg1 : tensor<6x11xf32>, tensor<6x11xf32>) outs(%arg2 : tensor<6x11xf32>) -> tensor<6x11xf32>
      NAIL.yield %z : tensor<6x11xf32>
    }
    return %r : tensor<6x11xf32>
  }
}
