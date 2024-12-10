let () =
  Day3.Input.read()
  |> fun input -> (match Sys.argv.(1) with
  | "part1" -> Day3.Part1.run(input)
  | "part2" -> Day3.Part2.run(input)
  | _ -> raise (Invalid_argument "Invalid argument"))
  |> print_int
