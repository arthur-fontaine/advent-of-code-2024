let count_horizontally word input =
  let res = ref 0 in
  String.split_on_char '\n' input
  |> List.iter (fun line -> (
    res := !res + (Utils.count_occurrences word line);
    res := !res + (Utils.count_occurrences (Utils.strrev word) line)
  ));
  !res

let count_vertically word input =
  String.split_on_char '\n' input
  |> List.map Utils.explode
  |> Utils.transpose
  |> List.map Utils.string_of_chars
  |> String.concat "\n"
  |> count_horizontally word

let char_at_or_empty i j input' =
  let input = input' |> Array.of_list in
  try
    String.make 1 (String.get input.(i) j)
  with Invalid_argument _ -> ""

let get_diagonals_for_4 input i j = [
  char_at_or_empty i j input ^ char_at_or_empty (i + 1) (j + 1) input ^ char_at_or_empty (i + 2) (j + 2) input ^ char_at_or_empty (i + 3) (j + 3) input;
  char_at_or_empty i j input ^ char_at_or_empty (i + 1) (j - 1) input ^ char_at_or_empty (i + 2) (j - 2) input ^ char_at_or_empty (i + 3) (j - 3) input;
  char_at_or_empty i j input ^ char_at_or_empty (i - 1) (j + 1) input ^ char_at_or_empty (i - 2) (j + 2) input ^ char_at_or_empty (i - 3) (j + 3) input;
  char_at_or_empty i j input ^ char_at_or_empty (i - 1) (j - 1) input ^ char_at_or_empty (i - 2) (j - 2) input ^ char_at_or_empty (i - 3) (j - 3) input;
]


let count_diagonally word input' =
  let res = ref 0 in
  let input = String.split_on_char '\n' input' in
  input
  |> List.map Utils.explode
  |> List.iteri (fun i line -> (
    List.iteri (fun j _ -> (
      get_diagonals_for_4 input i j
      |> List.iter (fun diagonal -> (
        if Utils.string_contains_word word diagonal then
          res := !res + 1
      ))
    )) line
  ))
  |> ignore;
  !res

let run input' =
  let input = String.trim input' in
  count_horizontally "XMAS" input
  |> (+) (count_vertically "XMAS" input)
  |> (+) (count_diagonally "XMAS" input)
