let () =
  Day3.Input.read()
  |> Day3.Part1.get_muls
  |> Day3.Part1.apply_muls
  |> string_of_int
  |> print_string
