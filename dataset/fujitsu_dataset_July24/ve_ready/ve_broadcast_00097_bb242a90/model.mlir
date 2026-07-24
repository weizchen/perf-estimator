module {
  func.func @kernel(%arg0: tensor<9x12xbf16>, %arg1: tensor<9x224x12xbf16>) -> tensor<9x224x12xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<9x224x12xbf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<9x12xbf16>) outs(%arg1 : tensor<9x224x12xbf16>) dimensions = [1]
      NAIL.yield %z : tensor<9x224x12xbf16>
    }
    return %r : tensor<9x224x12xbf16>
  }
}
