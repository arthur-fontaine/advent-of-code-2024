let () =
  Day3.Input.read()
  |> Day3.Part2.get_instrs
  |> Day3.Part2.treat_instrs
  |> print_int
