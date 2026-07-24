module {
  func.func @kernel(%arg0: tensor<1025xi16>, %arg1: tensor<1025xi16>) -> tensor<1025xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1025xi16> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<1025xi16>) outs(%arg1 : tensor<1025xi16>) {
    ^bb0(%in: i16, %out: i16):
      %0 = arith.addi %in, %out : i16
      %1 = arith.muli %in, %0 : i16
      %2 = arith.addi %in, %1 : i16
      %3 = arith.muli %in, %2 : i16
      %4 = arith.addi %in, %3 : i16
      %5 = arith.muli %in, %4 : i16
      %6 = arith.addi %in, %5 : i16
      %7 = arith.muli %in, %6 : i16
      linalg.yield %7 : i16
    } -> tensor<1025xi16>
      NAIL.yield %g : tensor<1025xi16>
    }
    return %r : tensor<1025xi16>
  }
}
