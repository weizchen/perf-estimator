module {
  func.func @kernel(%arg0: tensor<377x417xi1>, %arg1: tensor<377x417xbf16>, %arg2: tensor<377x417xbf16>, %arg3: tensor<377x417xbf16>) -> tensor<377x417xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<377x417xbf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<377x417xi1>, tensor<377x417xbf16>, tensor<377x417xbf16>) outs(%arg3 : tensor<377x417xbf16>) -> tensor<377x417xbf16>
      NAIL.yield %z : tensor<377x417xbf16>
    }
    return %r : tensor<377x417xbf16>
  }
}
