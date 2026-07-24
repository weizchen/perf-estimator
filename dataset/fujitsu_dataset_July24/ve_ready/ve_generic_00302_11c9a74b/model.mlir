module {
  func.func @kernel(%arg0: tensor<21xi8>, %arg1: tensor<21xi8>) -> tensor<21xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<21xi8> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<21xi8>) outs(%arg1 : tensor<21xi8>) {
    ^bb0(%in: i8, %out: i8):
      %0 = arith.addi %in, %out : i8
      %1 = arith.muli %in, %0 : i8
      %2 = arith.addi %in, %1 : i8
      %3 = arith.muli %in, %2 : i8
      %4 = arith.addi %in, %3 : i8
      %5 = arith.muli %in, %4 : i8
      %6 = arith.addi %in, %5 : i8
      %7 = arith.muli %in, %6 : i8
      linalg.yield %7 : i8
    } -> tensor<21xi8>
      NAIL.yield %g : tensor<21xi8>
    }
    return %r : tensor<21xi8>
  }
}
