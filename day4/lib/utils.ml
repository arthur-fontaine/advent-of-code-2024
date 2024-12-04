let transpose l =
  let rec transpose' acc = function
    | [] -> acc
    | [] :: _ -> List.rev acc
    | rows -> transpose' (List.map List.hd rows :: acc) (List.map List.tl rows)
  in
  transpose' [] l

let explode s = List.init (String.length s) (String.get s)

let string_of_chars chars =
  let buf = Buffer.create 16 in
  List.iter (Buffer.add_char buf) chars;
  Buffer.contents buf

let strrev x =
  let len = String.length x in
  String.init len (fun n -> String.get x (len - n - 1));;

let string_contains_word word s =
  let re = Str.regexp_string word in
  try ignore (Str.search_forward re s 0); true
  with Not_found -> false

let count_occurrences w s =
  let rec count' i n =
    try
      let n' = if String.sub s i (String.length w) = w then n + 1 else n in
      count' (i + 1) n'
    with Invalid_argument _ -> n;
  in
  count' 0 0
