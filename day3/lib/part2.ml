let get_instrs input =
  let re = Re.Perl.re "(?:mul\\([0-9]+,[0-9]+\\)|(?:do\\(\\))|(?:don't\\(\\)))" in
  let re_compiled = Re.Perl.compile re in
  Re.all re_compiled input
  |> List.map (fun group -> Re.Group.get group 0)

let treat_mul_instr instr =
  String.sub instr 4 (String.length instr - 5)
  |> String.split_on_char ','
  |> List.map int_of_string
  |> fun l -> (List.nth l 0 * List.nth l 1)

let treat_instrs instrs =
  let do_ref = ref true in
  instrs
  |> List.map (fun instr ->
      match instr with
      | "do()" -> do_ref := true; 0
      | "don't()" -> do_ref := false; 0
      | _ -> if !do_ref then treat_mul_instr instr else 0)
  |> List.fold_left (+) 0
