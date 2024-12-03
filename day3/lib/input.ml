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
