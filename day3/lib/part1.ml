let get_muls input =
  let re = Re.Perl.re "mul\\(([0-9]+),([0-9]+)\\)" in
  let re_compiled = Re.Perl.compile re in
  Re.all re_compiled input
  |> List.map (fun group ->
         let x = Re.Group.get group 1 in
         let y = Re.Group.get group 2 in
         (int_of_string x, int_of_string y))

let apply_muls muls =
  muls
  |> List.fold_left (fun acc (x, y) -> acc + (x * y)) 0
