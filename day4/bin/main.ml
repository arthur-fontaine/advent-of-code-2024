let () =
  Day4.Input.read()
  |> fun input -> (match Sys.argv.(1) with
  | "part1" -> Day4.Part1.run(input)
  | "part2" -> Day4.Part2.run(input)
  | _ -> raise (Invalid_argument "Invalid argument"))
  |> print_int
