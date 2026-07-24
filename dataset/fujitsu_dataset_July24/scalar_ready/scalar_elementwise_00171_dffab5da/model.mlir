module {
  func.func @kernel(%arg0: tensor<81xi16>, %arg1: tensor<81xi16>, %arg2: tensor<81xi16>) -> tensor<81xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<81xi16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<add> ins(%arg0, %arg1 : tensor<81xi16>, tensor<81xi16>) outs(%arg2 : tensor<81xi16>) -> tensor<81xi16>
      NAIL.yield %z : tensor<81xi16>
    }
    return %r : tensor<81xi16>
  }
}
