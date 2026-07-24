module {
  func.func @kernel(%arg0: tensor<228x507xi1>, %arg1: tensor<228x507xf32>, %arg2: tensor<228x507xf32>, %arg3: tensor<228x507xf32>) -> tensor<228x507xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<228x507xf32> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<228x507xi1>, tensor<228x507xf32>, tensor<228x507xf32>) outs(%arg3 : tensor<228x507xf32>) -> tensor<228x507xf32>
      NAIL.yield %z : tensor<228x507xf32>
    }
    return %r : tensor<228x507xf32>
  }
}
