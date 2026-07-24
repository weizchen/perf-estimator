module {
  func.func @kernel(%arg0: tensor<20xi8>, %arg1: tensor<i8>) -> tensor<i8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<i8> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%arg0 : tensor<20xi8>) outs(%arg1 : tensor<i8>) {
    ^bb0(%in: i8, %out: i8):
      %0 = arith.addi %in, %out : i8
      linalg.yield %0 : i8
    } -> tensor<i8>
      NAIL.yield %g : tensor<i8>
    }
    return %r : tensor<i8>
  }
}
