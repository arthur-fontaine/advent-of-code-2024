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

let check_update_pass_rule (update: update) ((before_rule, after_rule): rule) =
  let res = ref true in
  let before_index = List.find_index (fun (a) -> a == before_rule) update in
  List.iter (fun _ ->
    let after_index = List.find_index (fun (a) -> a == after_rule) update in
    if Option.is_some before_index && Option.is_some after_index && Option.get before_index > Option.get after_index then
      res := false
  ) update;
  !res

let check_update (update: update) (rules: rule list) =
  let res = ref true in
  List.iter (fun rule ->
    if not (check_update_pass_rule update rule) then
      res := false
  ) rules;
  !res

let check_updates (updates: update list) (rules: rule list) =
  List.filter (fun update -> check_update update rules) updates

let get_middle_of_update (update: update) =
  List.nth update (List.length update / 2)

let run input =
  let (rules, updates) = parse_input input in
  check_updates updates rules
  |> List.map get_middle_of_update
  |> List.fold_left (fun acc x -> acc + x) 0
