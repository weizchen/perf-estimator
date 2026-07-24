module {
  func.func @kernel(%arg0: tensor<115xi16>, %arg1: tensor<i16>) -> tensor<i16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<i16> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%arg0 : tensor<115xi16>) outs(%arg1 : tensor<i16>) {
    ^bb0(%in: i16, %out: i16):
      %0 = arith.addi %in, %out : i16
      linalg.yield %0 : i16
    } -> tensor<i16>
      NAIL.yield %g : tensor<i16>
    }
    return %r : tensor<i16>
  }
}
