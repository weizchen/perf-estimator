module {
  func.func @kernel(%arg0: tensor<105x6x87xi8>, %arg1: tensor<6x105x87xi8>) -> tensor<6x105x87xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<6x105x87xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<105x6x87xi8>) outs(%arg1 : tensor<6x105x87xi8>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<6x105x87xi8>
    }
    return %r : tensor<6x105x87xi8>
  }
}
