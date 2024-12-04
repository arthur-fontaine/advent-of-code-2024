let generate_squares_3 input' =
  let input = Utils.remove_chars ['\n'] input' in
  let number_of_lines = List.length (String.split_on_char '\n' input') in
  String.split_on_char '\n' input'
  |> List.map Utils.explode
  |> List.mapi (fun row_n l -> (
    let line_length = List.length l in
    List.mapi (fun col_n _ -> (
      if col_n <= line_length - 3 && row_n <= number_of_lines - 3 then
        Char.escaped (String.get input (row_n * line_length + col_n))
        |> (^) (Char.escaped (String.get input (row_n * line_length + col_n + 1)))
        |> (^) (Char.escaped (String.get input (row_n * line_length + col_n + 2)))
        |> (^) (Char.escaped (String.get input ((row_n + 1) * line_length + col_n)))
        |> (^) (Char.escaped (String.get input ((row_n + 1) * line_length + col_n + 1)))
        |> (^) (Char.escaped (String.get input ((row_n + 1) * line_length + col_n + 2)))
        |> (^) (Char.escaped (String.get input ((row_n + 2) * line_length + col_n)))
        |> (^) (Char.escaped (String.get input ((row_n + 2) * line_length + col_n + 1)))
        |> (^) (Char.escaped (String.get input ((row_n + 2) * line_length + col_n + 2)))
        |> Utils.strrev
      else
        ""
    )) l
  ))
  |> List.flatten
  |> List.filter (fun x -> String.length x != 0)

let is_x_mas input =
  let re = Re.Perl.re "(?:M.M.A.S.S)|(?:S.M.A.S.M)|(?:S.S.A.M.M)|(?:M.S.A.M.S)" in
  let re_compiled = Re.Perl.compile re in
  Re.execp re_compiled input


let run input' =
  let input = String.trim input' in
  generate_squares_3 input
  |> List.filter is_x_mas
  |> List.length
