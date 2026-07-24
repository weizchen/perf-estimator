module {
  func.func @kernel(%arg0: tensor<197x390xi1>, %arg1: tensor<197x390xbf16>, %arg2: tensor<197x390xbf16>, %arg3: tensor<197x390xbf16>) -> tensor<197x390xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<197x390xbf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<197x390xi1>, tensor<197x390xbf16>, tensor<197x390xbf16>) outs(%arg3 : tensor<197x390xbf16>) -> tensor<197x390xbf16>
      NAIL.yield %z : tensor<197x390xbf16>
    }
    return %r : tensor<197x390xbf16>
  }
}
