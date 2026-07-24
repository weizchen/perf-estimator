module {
  func.func @kernel(%arg0: tensor<228x48xf32>, %arg1: tensor<228x48xf32>) -> tensor<228x48xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<228x48xf32> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<tanh> ins(%arg0 : tensor<228x48xf32>) outs(%arg1 : tensor<228x48xf32>) -> tensor<228x48xf32>
      NAIL.yield %z : tensor<228x48xf32>
    }
    return %r : tensor<228x48xf32>
  }
}
