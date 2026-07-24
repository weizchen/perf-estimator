module {
  func.func @kernel(%arg0: tensor<458x170xi1>, %arg1: tensor<458x170xf16>, %arg2: tensor<458x170xf16>, %arg3: tensor<458x170xf16>) -> tensor<458x170xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<458x170xf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<458x170xi1>, tensor<458x170xf16>, tensor<458x170xf16>) outs(%arg3 : tensor<458x170xf16>) -> tensor<458x170xf16>
      NAIL.yield %z : tensor<458x170xf16>
    }
    return %r : tensor<458x170xf16>
  }
}
