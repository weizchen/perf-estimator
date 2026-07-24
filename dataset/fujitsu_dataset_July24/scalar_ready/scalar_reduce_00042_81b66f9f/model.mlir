module {
  func.func @kernel(%arg0: tensor<6x8x248xf16>, %arg1: tensor<8x248xf16>) -> tensor<8x248xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<8x248xf16> {
    %z = linalg.reduce ins(%arg0 : tensor<6x8x248xf16>) outs(%arg1 : tensor<8x248xf16>) dimensions = [0]
      (%in: f16, %acc: f16) {
        %s = arith.addf %in, %acc : f16
        linalg.yield %s : f16
      }
      NAIL.yield %z : tensor<8x248xf16>
    }
    return %r : tensor<8x248xf16>
  }
}
