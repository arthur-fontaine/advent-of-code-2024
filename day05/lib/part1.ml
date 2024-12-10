let check_update_pass_rule (update: Input.update) ((before_rule, after_rule): Input.rule) =
  let res = ref true in
  let before_index = List.find_index (fun (a) -> a == before_rule) update in
  List.iter (fun _ ->
    let after_index = List.find_index (fun (a) -> a == after_rule) update in
    if Option.is_some before_index && Option.is_some after_index && Option.get before_index > Option.get after_index then
      res := false
  ) update;
  !res

let check_update (update: Input.update) (rules: Input.rule list) =
  let res = ref true in
  List.iter (fun rule ->
    if not (check_update_pass_rule update rule) then
      res := false
  ) rules;
  !res

let check_updates (updates: Input.update list) (rules: Input.rule list) =
  List.filter (fun update -> check_update update rules) updates

let get_middle_of_update (update: Input.update) =
  List.nth update (List.length update / 2)

let run input =
  let (rules, updates) = Input.parse_input input in
  check_updates updates rules
  |> List.map get_middle_of_update
  |> List.fold_left (fun acc x -> acc + x) 0
