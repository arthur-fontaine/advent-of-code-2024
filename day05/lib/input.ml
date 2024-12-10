let read () =
  let ic = open_in "input.txt" in
    let buf = Buffer.create 1024 in
    try
      while true do
        let line = input_line ic in
        Buffer.add_string buf (line ^ "\n")
      done;
      assert false
    with
    | End_of_file ->
      close_in ic;
      Buffer.contents buf

type rule = int * int
type update = int list

let parse_update update =
  String.split_on_char ',' update
  |> List.map int_of_string

let parse_updates input =
  String.split_on_char '\n' input
  |> List.map parse_update

let parse_rule rule: rule =
  let parts = String.split_on_char '|' rule in
  (int_of_string (List.nth parts 0), int_of_string (List.nth parts 1))

let parse_rules input =
  String.split_on_char '\n' input
  |> List.map parse_rule

let parse_input input =
  let re = Str.regexp "\n\n" in
  let parts = Str.split re (String.trim input) in
  (parse_rules (List.nth parts 0), parse_updates (List.nth parts 1))
