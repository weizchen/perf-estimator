module {
  func.func @kernel(%arg0: tensor<22xf16>, %arg1: tensor<22xf16>) -> tensor<22xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<22xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<negf> ins(%arg0 : tensor<22xf16>) outs(%arg1 : tensor<22xf16>) -> tensor<22xf16>
      NAIL.yield %z : tensor<22xf16>
    }
    return %r : tensor<22xf16>
  }
}
