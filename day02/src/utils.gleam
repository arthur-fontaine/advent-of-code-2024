import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn read_input(path) {
  use file <- result.map(simplifile.read(path))

  file
  |> string.trim
}

pub fn void(_) {
  Nil
}

pub fn list_append(l, el) {
  [el, ..list.reverse(l)] |> list.reverse
}
